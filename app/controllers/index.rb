get '/' do
  url = "https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_API_ID']}&response_type=code&redirect_uri=#{redirect_uri}&scope=user-read-email%20user-library-read%20user-follow-read%20user-follow-modify%20playlist-modify-public&state=#{ENV['STATE']}"
  #full list of scopes at https://developer.spotify.com/web-api/using-scopes/
  erb :index, locals: {url: url}
end

get '/reauthorize' do
  erb :reauthorize #reauthenticate user with Spotify if token timed out
end

get '/oauth_callback' do
  puts "in oauth callback"
  if params[:state] == ENV['STATE']
    if params[:code]
      fetch_api_token(params[:code])
      # binding.pry
      redirect '/'
    else
      puts "OAuth Error: #{params[:error]}"
    end
  else
    halt 403, "Unauthorized - state mismatch"
  end
end

