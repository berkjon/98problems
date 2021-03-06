### CONTROLLER HELPERS ###
def spotify_login_url
  return "https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_API_ID']}&response_type=code&redirect_uri=#{redirect_uri}&scope=user-read-email%20user-library-read%20user-follow-read%20user-follow-modify%20playlist-modify-public&state=#{ENV['STATE']}"
  #full list of scopes at https://developer.spotify.com/web-api/using-scopes/
end

def redirect_uri
  return 'http://127.0.0.1:9393/oauth_callback'
end

def fetch_api_token(authorization_code)
  oauth_tokens = HTTParty.post('https://accounts.spotify.com/api/token', query: {
    grant_type: 'authorization_code',
    code: authorization_code,
    redirect_uri: redirect_uri,
    client_id: ENV['SPOTIFY_API_ID'],
    client_secret: ENV['SPOTIFY_API_SECRET']})
  fetch_user_info(oauth_tokens) #returns the user object if successful authentication
end

def fetch_user_info(oauth_tokens)
  user_info = HTTParty.get('https://api.spotify.com/v1/me', headers: {"Authorization" => "Bearer #{oauth_tokens['access_token']}"})
  if user_info['error']
    puts "Error fetching user info: #{user_info['error']}"
    return nil
  else
    find_or_create_user(user_info, oauth_tokens)
  end
end

#move to User model?
def find_or_create_user(user_info, oauth_tokens)
  user = User.where(spotify_id: user_info['id']).first
  if user.nil?
    user = User.create(
      spotify_id: user_info['id'],
      access_token: oauth_tokens['access_token'],
      access_token_duration: oauth_tokens['expires_in'],
      access_token_created_at: Time.now, #why is this returning an incorrect time?
      refresh_token: oauth_tokens['refresh_token'],
      display_name: user_info['display_name'],
      email: user_info['email'],
      photo_url: user_info['images'].first['url'],
      profile_url: user_info['external_urls']['spotify'],
    )
    session[:id] = user.id
    fetch_saved_tracks #load saved tracks into DB if first-time user
  else #if previous user but no token
    user.access_token = oauth_tokens['access_token']
    user.access_token_duration = oauth_tokens['expires_in']
    user.access_token_created_at = Time.now
    user.refresh_token = oauth_tokens['refresh_token']
    user.save
  end
  session[:id] = user.id
  return user
end

#does this belong in User model instead?
def access_token_expired?(user)
  if user.access_token_created_at.nil?
    return true
  else
    elapsed_time = ((Time.now - user.access_token_created_at)/60).round(2)
    time_remaining = user.access_token_duration - elapsed_time
    return time_remaining < 0
  end
end

def token_expired_but_have_refresh_token?(user)
  access_token_expired?(user) && user.refresh_token
end

def use_best_token(user)
  if !access_token_expired?(user) #if token is NOT expired
    return user.access_token
  elsif token_expired_but_have_refresh_token?(user)
    return refresh_token(user) # returns new token
  else #token is expired and we don't have a refresh token
    return nil #should trigger redirect to user reauthentication
  end
end

def refresh_token(user)
  new_token = HTTParty.post('https://accounts.spotify.com/api/token', query: {
  grant_type: 'refresh_token',
  refresh_token: "#{user.refresh_token}",
  client_id: ENV['SPOTIFY_API_ID'],
  client_secret: ENV['SPOTIFY_API_SECRET']})

  if new_token['access_token']
    user.access_token = new_token['access_token']
    user.access_token_duration = new_token['expires_in']
    user.access_token_created_at = Time.now
    user.refresh_token = new_token['refresh_token'] #will set to nil if no new refresh token received
    # user.save!
    return new_token['access_token']
  else
    puts "Error refreshing token: #{new_token['error']}"
    return nil
  end
end

def current_user
  @current_user ||= User.find(session[:id]) if session[:id]
end

def logged_in_and_active_token?
  if !current_user.nil? #if there is a user_id in sessions
    if !access_token_expired?(current_user) #if access token is still valid
      return true
    elsif token_expired_but_have_refresh_token?(current_user)
      refresh_token(current_user)
      return true
    else
      return false
    end
    return false
  end
end

def logged_in?
  !current_user.nil?
end

def logout!
  current_user.access_token = nil
  current_user.access_token_duration = nil
  current_user.access_token_created_at = nil
  current_user.refresh_token = nil
  current_user.save
  session.clear
end
