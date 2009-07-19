class UsersController < ApplicationController
  before_filter :login_required, :only => %w(edit update)

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
    if user?(@user)
      render :new
    else
      flash[:notice] = "You must own him/her!"
      redirect_to root_url
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def list
    @user = User.find(params[:id])
    @desires = @user.desires
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      login_as @user
      flash[:notice] = "Happy birthday to you!"
      redirect_to(@user)
    else
      render :new
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    if user?(@user)
      if @user.update_attributes(params[:user])
        flash[:notice] = "Update successful!"
        redirect_to @user
      else
        render :new
      end
    else
      flash[:notice] = "You must own him/her!"
      redirect_to root_url
    end
  end
end
