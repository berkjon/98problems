class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :tag_usertracks
  has_many :user_tracks, through: :tag_usertracks
  has_many :tracks, through: :user_tracks
  has_many :playlist_usertracks, through: :user_tracks
  has_many :playlists, through: :playlist_usertracks

  def link_to_usertrack(user_id, track_id)
    usertrack = UserTrack.where(user_id: user_id, track_id: track_id).first
    raise "Can't find valid usertrack for track #{track_id} and user #{user_id}" if usertrack.nil?
    TagUsertrack.create(tag_id: self.id, user_track_id: usertrack.id)
  end

end