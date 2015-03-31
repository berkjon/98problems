class Track < ActiveRecord::Base
  has_many :playlist_tracks
  has_many :track_tags
  has_many :users, through: :playlists
  has_many :playlists, through: :playlist_tracks
  has_many :tags, through: :track_tags

  after_commit :add_to_library, on: :create #must be after_commit in order to pull user_id

  def add_to_library #when a track is added to a user's playlist, automatically add it to their Library too
    library_ids = []
    self.users.each do |user|
      library_ids << user.playlists.where(name: "Library-#{user.id}").first.id
    end
    library_ids.each do |library_id|
      PlaylistTrack.create(playlist_id: library_id, track_id: self.id)
    end
  end
end