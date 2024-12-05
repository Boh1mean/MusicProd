class Track < ApplicationRecord
  validates :name, presence: true
  validates :cloud_url, presence: true
end
