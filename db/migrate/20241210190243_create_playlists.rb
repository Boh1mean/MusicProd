class CreatePlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :playlists do |t|
        t.string :name, null: false
        t.string :kind, null: false
        t.string :artwork_url, null: false
        t.string :url, null: false

        t.timestamps
      end

      create_table :playlist_tracks do |t|
        t.references :playlist, null: false, foreign_key: true
        t.references :track, null: false, foreign_key: true

        t.timestamps
    end
  end
end
