class Playlist < ApplicationRecord
  belongs_to :user, optional: true
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  validates :name, :kind, :artwork_url, :url, presence: true

  def self.find_or_create_liked_playlist(user, track)
    find_or_create_by!(user: user, name: "Понравившееся", kind: "liked") do |pl|
      pl.url = "#"
      pl.artwork_url = track.artwork_url.presence || "https://storage.yandexcloud.net/music-servise-bucker1/artwork.jpg"
    end
  end
end
