class UserTrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  has_many :playlist_usertracks
  has_many :playlists, through: :playlist_usertracks
  has_many :tag_usertracks
  has_many :tags, through: :tag_usertracks

end