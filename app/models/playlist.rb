class Playlist < ActiveRecord::Base
  has_many :playlist_usertracks
  has_many :user_tracks, through: :playlist_usertracks
  has_many :users, through: :users_tracks
  has_many :tracks, through: :user_tracks
  has_many :tag_usertracks, through: :user_tracks
  has_many :tags, through: :tag_usertracks
end