class User < ActiveRecord::Base
  has_many :user_tracks
  has_many :tracks, through: :user_tracks
  has_many :playlist_usertracks, through: :user_tracks
  has_many :playlists, through: :playlist_usertracks
  has_many :tag_usertracks, through: :user_tracks
  has_many :tags, through: :tag_usertracks

  # after_create :create_library_playlist

  # def create_library_playlist
  #   self.playlists.create(name: "Library-#{self.id}")
  #   self.save
  # end

end

### How can I configure to allow for User.first.tracks.create() ?  Currently throws error b/c goes through Playlist