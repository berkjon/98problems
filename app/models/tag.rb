class Tag < ActiveRecord::Base
  has_many :track_tags

  has_many :users, through: :tracks
  has_many :playlists, through: :tracks
  has_many :tracks, through: :track_tags
end