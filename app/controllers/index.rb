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

post '/users/:user_id/tracks/:track_id/tags/add' do
  params[:tag][0] == "#" ? tag_string = params[:tag][1..-1].downcase : tag_string = params[:tag].downcase #move to controller helper method?
  current_tag = current_user.tags.find_or_create_by(name: tag_string)
  current_tag.link_to_usertrack(current_user.id, params[:track_id])
  redirect "/users/#{params[:user_id]}"
end




get '/clear_session' do
  session.clear
  redirect '/'
end

get '/logout' do
  logout!
  redirect '/'
end