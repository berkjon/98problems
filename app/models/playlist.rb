class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_usertracks
  has_many :user_tracks, through: :playlist_usertracks
  has_many :tracks, through: :user_tracks
  has_many :tag_usertracks, through: :user_tracks
  has_many :tags, through: :tag_usertracks
end

