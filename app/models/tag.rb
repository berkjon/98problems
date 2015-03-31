class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :tag_usertracks
  has_many :user_tracks, through: :tag_usertracks
  has_many :tracks, through: :user_tracks
  has_many :playlist_usertracks, through: :user_tracks
  has_many :playlists, through: :playlist_usertracks
end