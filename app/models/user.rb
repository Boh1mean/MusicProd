# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :tracks
  has_many :playlists
  has_many :liked_tracks, through: :liked_tracks_playlists, source: :tracks

  validates :name, presence: true
end
