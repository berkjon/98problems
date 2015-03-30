class User < ActiveRecord::Base
  has_many :user_playlists
  has_many :playlists, through: :user_playlists

  has_many :user_tracks
  has_many :tracks, through: :user_tracks
  has_many :tracks, through: :playlists
  has_many :tags, through: :tracks
  has_many :tags, through: :playlists
end