class AddUniqueIndexToPlaylistTracks < ActiveRecord::Migration[8.0]
  def change
    add_index :playlist_tracks, [ :playlist_id, :track_id ], unique: true, name: "index_playlist_tracks_uniqueness"
  end
end
