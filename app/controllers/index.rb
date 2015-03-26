get '/' do
  url = "https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_API_ID']}&response_type=code&redirect_uri=#{redirect_uri}&scope=user-read-email%20user-library-read%20user-follow-read%20user-follow-modify%20playlist-modify-public&state=foobar1"
  erb :index
end

get '/login' do
  puts "redirect uri: #{redirect_uri}"
  session[:temp_session_hash] = session.hash
  # response = HTTParty.get("https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_API_ID']}&response_type=code&redirect_uri=#{redirect_uri}")
  # p "***********"
  # p "https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_API_ID']}&response_type=code&redirect_uri=#{redirect_uri}"
  # binding.pry
    # &scope=user-read-email%20user-library-read%20user-follow-read%20user-follow-modify%20playlist-modify-public&state=#{session[:temp_session_hash]}")
  #full list of scopes at https://developer.spotify.com/web-api/using-scopes/
  #add 'state' hash/random variable to above oauth request, for security
  # return "test1234"
  "<a href='#{url}'>click me!</a>"
end

get '/signup' do
  puts 'test inside signup'
end

get '/oauth_callback/' do
  puts "inside wrong oauth_callback path"
end

get '/oauth_callback' do
  puts "in oauth callback"
  puts session[:temp_session_hash]
  if params[:state] == session[:temp_session_hash]
    if @auth_code = params[:code]
      response = HTTParty.post('https://accounts.spotify.com/api/token',
        query: {
          grant_type: 'authorization_code',
          code: @auth_code,
          redirect_uri: redirect_uri, # method from auth.rb helper
          client_id: ENV['SPOTIFY_API_ID'],
          client_secret: ENV['SPOTIFY_API_SECRET']
        }
      )
      redirect '/'
    else
      puts "ERROR: #{params[:error]}"
    end
  else
    puts "FAILED due to state mismatch:"
    puts "session hash: #{session[:temp_session_hash]}"
    puts "returned state: #{params[:state]}"
  end

  puts "RESPONSE: #{response}"

end

get '/api/facebook/oauth/access_token' do
  puts "inside /api/facebook/oauth/access_token "
end

