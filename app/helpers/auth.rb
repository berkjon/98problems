### CONTROLLER HELPERS ###
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
    # binding.pry
  end
end

#does this belong in User model instead?
def access_token_expired?(user)
  elapsed_time = ((Time.now - user.access_token_created_at)/60).round(2)
  time_remaining = user.access_token_duration - elapsed_time
  return time_remaining < 0
end

def use_best_token(user)
  if !access_token_expired? #if token is NOT expired
    return user.access_token
  elsif access_token_expired?(user) && user.refresh_token #if token expired but user has a refresh token
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
    return new_token['access_token']
  else
    puts "Error refreshing token: #{new_token['error']}"
    return nil
  end
end

#move to User model?
def find_or_create_user(user_info, oauth_tokens)
  spotify_id = user_info['id']
  user = User.find_or_initialize_by(spotify_id: spotify_id)
  user.access_token = oauth_tokens['access_token']
  user.access_token_duration = oauth_tokens['expires_in']
  user.access_token_created_at = Time.now #why is this returning an incorrect time?
  user.refresh_token = oauth_tokens['refresh_token']
  user.display_name = user_info['display_name']
  user.email = user_info['email']
  user.photo_url = user_info['images'].first['url']
  user.profile_url = user_info['external_urls']['spotify']
  user.save
  session[:user_id] = user.id
  return user
end

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end

def logged_in?
  !current_user.nil?
end

def logout
  session.clear
end
