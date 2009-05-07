class MainController < ApplicationController
  # GET /
  def index
    @user = User.new
  end
    
  # POST /session
  def create
    reset_session
    u = User.authenticate(params[:session][:login], params[:session][:password]) 
    
    if u
      login_as u
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
