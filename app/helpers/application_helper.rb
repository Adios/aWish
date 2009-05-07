# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    session[:user_id].nil? ? false : true
  end
  
  def user_owned? res
    return true if logged_in? and res.user_id? and res.user_id == session[:user_id]
    false
  end
  
  def user? user
    return true if session[:user_id] and user.id == session[:user_id]
    false
  end
end
