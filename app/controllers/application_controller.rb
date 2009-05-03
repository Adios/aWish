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
end
