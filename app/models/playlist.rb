class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  validates :name, :kind, :artwork_url, :url, presence: true

  def self.find_or_create_liked_playlist(user, track)
    find_or_create_by!(user: user, name: "Понравившееся", kind: "liked", url: "#")
  end
end
