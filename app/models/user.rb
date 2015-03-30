class User < ActiveRecord::Base
  has_many :user_playlists

  has_many :playlists, through: :user_playlists
  has_many :tracks, through: :playlists
  has_many :tags, through: :tracks
end