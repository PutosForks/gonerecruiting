require_relative  'convert_height.rb'

class UsersController < ApplicationController
  before_action :require_current_user!, except: [:create, :new, :index]
  skip_before_action :verify_authenticity_token
  before_action :check_for_reset, :only => [:create, :update]

  ##Need to change where the root route goes!!
  def index
      render :home
  end

  def create
    # sign up the user
    if !User.all.where('username = ?', params['user']["username"]).nil? 
        ##error message -- redirect back to signup page
        flash[:alert] = "Username is already taken.  Please choose a different username."
        redirect_back fallback_location: "/user/new"
    elsif !User.all.where('email = ?', user["email"]).nil?
        ##error message --redirect back to signup page
        flash[:alert] = "That email address is already in use.  Please try again."
        redirect_back fallback_location: "/user/new"
    else
        @user = User.new(user_params)
        if @user.save
        # redirect them to the new user's show page
        login!(@user)
        UserMailer.with(user: @user).welcome_email.deliver_later
        redirect_to user_url(@user)
        end
    end    
  end

  def new
    # present form for signup
    @user = User.new # dummy user object
    render :new
  end

  def show
    # show the user's details (just their username)
    if current_user.nil?
      # let them log in
      redirect_to new_session_url
      return
    end

    @targetgames = get_targetgames(current_user)
    @todos = get_todos(current_user)
    @recruits = get_recruits(current_user)
    @players = get_players(@recruits)
    @user = current_user
    render :show
  end

  def filter
      @players = filter_without_rendering()
      @user = current_user
      render :show
  end

  protected
  def user_params
    self.params.require(:user).permit(:username, :password, :password_confirmation, :email, :first_name, :last_name, :phone, :organization)
  end

  def get_todos(user)
    todos = Todo.where("user_id = ?", user.id)
    todos = todos.where("completed = ?", false)
    todos = todos.to_a

    return todos
  end

  def check_for_reset
    if params[:commit] == "Reset"
      redirect_to my_page_path
    end
  end

  def get_recruits(current_user)
    recruits = Recruit.where("user_id = ?", current_user.id)
    id_array = []
    recruits.each do |recruit|
      id_array << recruit.player_id
    end
        
    return id_array
  end

  def get_players(recruits)
    recruits = recruits.flatten.uniq


    recruits.each_with_index do |recruit, i|
      if i == 0
        @list = Player.where("id = ?", recruit)
      else
        @list = @list.or(Player.where("id = ?", recruit))
      end
    end

    return @list
  end

  def get_targetgames(user)
    targetgames = Targetgame.where("user_id = ?", user.id)
    finally = []
    targetgames.each do |game|
      finally << Contest.where("id = ?", game.contest_id)
    end

    return finally.flatten
  end

  def filter_without_rendering
        player_name = params["filter"]["name"].downcase
        height = params["filter"]["height"]
        position = params["filter"]["position"]
        school = params["filter"]["school"].downcase
        grade = params["filter"]["grade"]

        if !height.nil?
            converted_height = convert_height(height)
            if @players.nil?
                @players = Player.height_filter(converted_height)
            else
                @players = @players.height_filter(converted_height)
            end
        end

        if grade != "" && !grade.nil?
            if @players.nil?
                @players = Player.grade_filter(grade)
            else
                @players = @players.grade_filter(grade)
            end
        end

        if !position.nil?
            if @players.nil?
                @players = Player.position_filter(position)
            else
                @players = @players.position_filter(position)
            end
        end

        if school != ""
            if @players.nil?
                @players = Player.school_filter(school)
            else
                @players = @players.school_filter(school)
            end
        end

        if player_name != "" && !player_name.nil?
            if @players.nil?
                @players = Player.name_filter(player_name)
            else
                @players = @players.name_filter(player_name)
            end
        end

        recruits = Recruit.where("user_id = ?", current_user.id)
        
        players = recruits.map do |recruit|
          @players.where("id = ?", recruit.player_id)
        end

        return players.flatten.uniq
  end

  def bubble_sort(schedule)
    length = schedule.length
    loop do
      swapped = false
      (length - 1).times do |i|
        if schedule[i]["start_at"] > schedule[i + 1]["start_at"]
          schedule[i], schedule[i + 1] = schedule[i + 1], schedule[i]
          swapped = true
        end
      end

      break if swapped == false
    end
    
    return schedul
  end
end