class FixTracksTable < ActiveRecord::Migration[8.0]
  def change
    change_table :tracks do |t|
      t.string :artist_name unless column_exists?(:tracks, :artist_name)
      t.string :release_date unless column_exists?(:tracks, :release_date)
      t.string :kind unless column_exists?(:tracks, :kind)
      t.string :artist_id unless column_exists?(:tracks, :artist_id)
      t.string :artist_url unless column_exists?(:tracks, :artist_url)
      t.string :content_advisory_rating unless column_exists?(:tracks, :content_advisory_rating)
      t.string :artwork_url unless column_exists?(:tracks, :artwork_url)

      unless column_exists?(:tracks, :genres)
        t.text :genres, array: true, default: []
      end
    end
  end
end