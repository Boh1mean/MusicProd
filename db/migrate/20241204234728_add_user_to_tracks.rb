class AddUserToTracks < ActiveRecord::Migration[8.0]
  def change
    add_reference :tracks, :user, null: false, foreign_key: true
  end
end
