class Playlist < ActiveRecord::Base
  has_many :user_playlists
  has_many :playlist_tracks

  has_many :users, through: :user_playlists
  has_many :tracks, through: :playlist_tracks
  has_many :tags, through: :tracks
end