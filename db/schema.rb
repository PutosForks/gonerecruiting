# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_18_002124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "athletic_directors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "school_id"
    t.string "phone"
    t.string "email"
    t.string "cell"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifications", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name", null: false
    t.string "cell"
    t.string "phone"
    t.string "email"
    t.integer "team_id"
    t.integer "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name", null: false
    t.integer "classification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.string "position"
    t.string "height"
    t.string "grade"
    t.string "home_number"
    t.string "away_number"
    t.integer "team_id", null: false
    t.integer "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "mascot"
    t.integer "league"
    t.string "color_1"
    t.string "color_2"
    t.string "color_3"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "osaa_school_id"
    t.string "social_media"
    t.integer "classification"
    t.index ["osaa_school_id"], name: "index_schools_on_osaa_school_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.integer "school_id"
    t.integer "coach_id"
    t.integer "club_id"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.integer "osaa_school_id"
    t.integer "osaa_team_id"
    t.string "social_media"
    t.string "team_photo_url"
    t.index ["osaa_school_id"], name: "index_teams_on_osaa_school_id", unique: true
    t.index ["osaa_team_id"], name: "index_teams_on_osaa_team_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_token", null: false
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
  end

end
