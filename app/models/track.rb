class Track < ActiveRecord::Base
  has_many :playlist_tracks
  has_many :track_tags

  has_many :users, through: :playlists

  has_many :playlists, through: :playlist_tracks
  has_many :tags, through: :track_tags

  after_create :add_to_library

  def add_to_library
    library_playlist = Playlist.where(name: 'Library').first
    PlaylistTrack.create(playlist_id: library_playlist, track_id: self.id)
  end

end