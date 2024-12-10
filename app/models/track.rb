class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlist, through: :playlist_tracks


  validates :name, :cloud_url, :artist_name, presence: true

  validates :release_date, :kind,
            :artist_id, :artist_url, :artwork_url, :genres, presence: false
end
