class PlaylistUsertrack < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :user_track
end
