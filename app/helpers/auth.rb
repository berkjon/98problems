def redirect_uri
  # return 'http%3A%2F%2F127.0.0.1%3A9393%2Foauth_callback'
  return 'http://127.0.0.1:9393/oauth_callback'
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
