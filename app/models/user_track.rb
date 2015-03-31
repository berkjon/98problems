class UserTrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  has_many :playlist_usertracks
  has_many :tag_usertracks
end