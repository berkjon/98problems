class User < ActiveRecord::Base
  has_many :user_tracks
  has_many :playlists
  has_many :tags
  has_many :tracks, through: :user_tracks

  # after_create :create_library_playlist

  # def create_library_playlist
  #   self.playlists.create(name: "Library-#{self.id}")
  #   self.save
  # end

  def matching_tracks(tag_ids)
    # tag_ids.sort_by!{|tag_id| Tag.find(tag_id).tracks.length}
    track_ids = []
    tag_ids.each do |tag_id|
      tracks = Tag.find(tag_id).tracks
      tracks.each do |track|
        track_ids << track.id
      end
    end
    track_id_count = Hash.new 0 #sets value to 0 by default
    track_ids.each do |track_id|
      track_id_count[track_id] += 1
    end
    tracks_with_all_tags = track_id_count.delete_if {|k,v| v < tag_ids.length}.map{|k,v| k}

    tracks_with_all_tags.map!{|id| Track.find(id)}
  end

end

### How can I configure to allow for User.first.tracks.create() ?  Currently throws error b/c goes through Playlist