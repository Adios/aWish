class MainController < ApplicationController
  # GET /
  def index
    @user = User.new
  end
    
  # POST /session
  def create
    u = User.authenticate(params[:session][:login], params[:session][:password]) 
    
    if u
      session[:user_id] = u.id
      session[:user_login] = u.login
      flash[:notice] = "Welcome back, #{u.login}!" 
      redirect_to user_path(u)
    else
      flash[:error] = "Invalid login or password!" 
      render :index
    end
  end
  
  # DELETE /session
  def destroy
    reset_session 
    flash[:notice] = "You've been logged out." 
    redirect_to root_url
  end
end
