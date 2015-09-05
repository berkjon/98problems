class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :tag_usertracks
  has_many :user_tracks, through: :tag_usertracks
  has_many :tracks, through: :user_tracks
  has_many :playlist_usertracks, through: :user_tracks
  has_many :playlists, through: :playlist_usertracks

  def link_to_usertrack(track_id)
    usertrack = UserTrack.where(user_id: self.user.id, track_id: track_id).first
    raise "Can't find valid usertrack for track #{track_id} and user #{user_id}" if usertrack.nil?
    TagUsertrack.create(tag_id: self.id, user_track_id: usertrack.id)
  end

  def destroy_tag_everywhere
    all_tagged_tracks = TagUsertrack.where(tag_id: self.id)
    all_tagged_tracks.destroy_all
    self.destroy
  end

end