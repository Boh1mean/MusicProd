class Track < ApplicationRecord
  before_validation :set_default_kind


  has_many :playlist_tracks, dependent: :destroy
  has_many :playlist, through: :playlist_tracks


  validates :name, :cloud_url, :artist_name, :kind, :artwork_url, presence: true
  validates :release_date, :artist_id, :artist_url, :genres, presence: false

  private

  def set_default_kind
    self.kind ||= "track"
  end
end
