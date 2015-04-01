helpers do

  def fetch_saved_tracks #fetch and load into database
    api_source_url = "https://api.spotify.com/v1/me/tracks?limit=50"
    request_counter = 1
    until (api_source_url.nil? || request_counter > 25 || response['error']) #load tracks into DB until no more left
      response = HTTParty.get("#{api_source_url}", headers: {"Authorization" => "Bearer #{current_user.access_token}"})
      raise "Error fetching tracks: #{response['error']}" if response['error']
      tracks_from_api = response['items']
      tracks_from_api.each do |track|
        track_in_db = find_or_create_track(track) #create track entry in db if not already there
        link_track_to_user(track_in_db)
      end
      api_source_url = response['next'] #update request URL for next set of tracks
      request_counter += 1
    end
  end

  def find_or_create_track(single_track_from_api)
    current_track = Track.where(spotify_id: single_track_from_api['track']['id']).first
    if current_track.nil?
      current_track = Track.create(
        spotify_id: single_track_from_api['track']['id'],
        title: single_track_from_api['track']['name'],
        cover_art: single_track_from_api['track']['album']['images'].first['url'],
        artist: single_track_from_api['track']['artists'].first['name'],
        artist_spotify_id: single_track_from_api['track']['artists'].first['id'],
        album: single_track_from_api['track']['album']['name'],
        album_spotify_id: single_track_from_api['track']['album']['id'],
      )
    end
    return current_track
  end

  def link_track_to_user(track)
    UserTrack.find_or_create_by(user_id: current_user.id, track_id: track.id)
  end

end