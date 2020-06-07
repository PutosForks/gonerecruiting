class AddIndexToNotesSecondTry < ActiveRecord::Migration[5.2]
  def change
    add_index :notes, :player_id
    add_index :notes, :user_id
  end
end
