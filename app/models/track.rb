class Track < ActiveRecord::Base
  has_many :playlist_tracks
  has_many :track_tags
  has_many :user_tracks

  has_many :users, through: :playlists
  has_many :users, through: :user_tracks

  has_many :playlists, through: :playlist_tracks
  has_many :tags, through: :track_tags

end