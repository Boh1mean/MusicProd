class UpdateTracksToSwitchClient < ActiveRecord::Migration[8.0]
  def change
    change_table :tracks do |t|
      t.string :artist_name, null: false
      t.string :release_date, null: false
      t.string :kind, null: false
      t.string :artist_id, null: false
      t.string :artist_url, null: false
      t.string :content_advisory_rating
      t.string :artwork_url, null: false
      t.text :genres, null: false, array: true, default: []
    end
  end
end
