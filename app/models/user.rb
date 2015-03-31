class User < ActiveRecord::Base
  has_many :user_playlists
  has_many :playlists, through: :user_playlists
  has_many :tracks, through: :playlists
  has_many :tags, through: :tracks

  after_create :create_library_playlist

  def create_library_playlist
    self.playlists.create(name: "Library-#{self.id}")
    self.save
  end

end

### How can I configure to allow for User.first.tracks.create() ?  Currently throws error b/c goes through Playlist