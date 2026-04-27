class Track < ApplicationRecord
  before_validation :set_default_kind

  belongs_to :user, optional: true
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks

  validates :name, :cloud_url, :artist_name, :kind, :artwork_url, presence: true

  private

  def set_default_kind
    self.kind ||= "track"
  end
end
