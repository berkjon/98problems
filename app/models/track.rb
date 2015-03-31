class Track < ActiveRecord::Base
  has_many :user_tracks
  has_many :users, through: :user_tracks
  has_many :playlist_usertracks, through: :user_tracks
  has_many :playlists, through: :playlist_usertracks
  has_many :tag_usertracks, through: :user_tracks
  has_many :tags, through: :tag_usertracks

  # after_commit :add_to_library, on: :create #must be after_commit in order to pull user_id

  # def add_to_library #when a track is added to a user's playlist, automatically add it to their Library too
  #   library_ids = []
  #   self.users.each do |user|
  #     library_ids << user.playlists.where(name: "Library-#{user.id}").first.id
  #   end
  #   library_ids.each do |library_id|
  #     PlaylistTrack.create(playlist_id: library_id, track_id: self.id)
  #   end
  # end

end