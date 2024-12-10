class Track < ApplicationRecord
  validates :name, :cloud_url, :artist_name, presence: true

  validates :release_date, :kind,
            :artist_id, :artist_url, :artwork_url, :genres, presence: false
end
