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

delete '/users/:user_id/tags/:tag_id/delete' do
  Tag.find(params[:tag_id]).destroy_tag_everywhere
  redirect "/users/#{params[:user_id]}" unless request.xhr?
end

post '/users/:user_id/tracks/:track_id/tags/add' do
  if request.xhr? #because JS file already removes leading '#' sign and converts to lowercase
    tag_string = params[:tag]
  else
    #move this to controller helper method?
    params[:tag][0] == "#" ? tag_string = params[:tag][1..-1].downcase : tag_string = params[:tag].downcase
  end
  current_tag = current_user.tags.find_or_create_by(name: tag_string)
  current_tag.link_to_usertrack(params[:track_id])
  if request.xhr?
    content_type :json
    {user_id: params[:user_id], track_id: params[:track_id], tag_id: current_tag.id, tag_string: tag_string}.to_json
    # erb :_tag_on_track, locals: {tag: tag}, layout: false
  else
    redirect "/users/#{params[:user_id]}"
  end
end

delete '/users/:user_id/tracks/:track_id/tags/:tag_id/remove' do
  usertrack_id = UserTrack.where(user_id: params[:user_id], track_id: params[:track_id]).first.id
  TagUsertrack.where(tag_id: params[:tag_id], user_track_id:usertrack_id).first.destroy
  redirect "/users/#{params[:user_id]}" unless request.xhr?
end

get '/users/:user_id/filter' do
  tag_ids = JSON.parse(params[:tag_ids])
  erb :_selected_tracks, locals: {tag_ids: tag_ids}, layout: false
  # binding.pry
end


get '/clear_session' do
  session.clear
  redirect '/'
end

get '/logout' do
  logout!
  redirect '/'
end