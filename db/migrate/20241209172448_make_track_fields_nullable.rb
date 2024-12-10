class MakeTrackFieldsNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tracks, :release_date, true
    change_column_null :tracks, :kind, true
    change_column_null :tracks, :artist_id, true
    change_column_null :tracks, :artist_url, true
    change_column_null :tracks, :artwork_url, true
    change_column_null :tracks, :genres, true
  end
end
