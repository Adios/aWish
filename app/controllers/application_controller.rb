class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  protected
  
  def login_required
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      flash[:notice] = "Please log in"
      redirect_to root_url
    end
  end
  
  def login_as u
    reset_session
    session[:user_id] = u.id
    session[:user_login] = u.login
    @current_user = User.find(session[:user_id])
  end
  
  def user_owned? res
    return true if @current_user and res.user_id? and res.user_id == @current_user.id
    false
  end
  
  def user? user
    return true if @current_user and user.id == @current_user.id
    false
  end
end
