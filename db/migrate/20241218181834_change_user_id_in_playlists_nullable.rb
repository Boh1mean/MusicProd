class ChangeUserIdInPlaylistsNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :playlists, :user_id, true
  end
end
