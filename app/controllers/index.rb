get '/' do
  if logged_in_and_active_token?
    user = User.find(id: session[:id])
    erb :index, locals: {user: user}
  else
    redirect '/welcome'
  end
  #full list of scopes at https://developer.spotify.com/web-api/using-scopes/
end

get '/welcome' do
  erb :welcome
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

