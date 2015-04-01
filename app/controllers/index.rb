get '/' do
  if logged_in_and_active_token?
    redirect "/users/#{current_user.id}"
  else
    erb :index
  end
end

get '/users/:user_id' do
  if logged_in_and_active_token?
    erb :user
  else
    redirect '/'
  end
end

# get '/reauthorize' do
#   erb :reauthorize #reauthenticate user with Spotify if token timed out
# end

get '/oauth_callback' do
  puts "in oauth callback"
  if params[:state] == ENV['STATE']
    if params[:code] #if spotify sent an authorization code
      fetch_api_token(params[:code])
      redirect '/'
    else
      puts "OAuth Error: #{params[:error]}"
    end
  else
    halt 403, "Unauthorized - state mismatch"
  end
end

get '/clear_session' do
  session.clear
  redirect '/'
end

get '/logout' do
  logout!
  redirect '/'
end