class AddUserToPlaylists < ActiveRecord::Migration[8.0]
  def change
    add_reference :playlists, :user, null: false, foreign_key: true
  end
end
