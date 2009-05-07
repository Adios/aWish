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
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        login_as @user
        flash[:notice] = "Happy birthday to you!"
        format.html { redirect_to(@user) }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if user?(@user)
        if @user.update_attributes(params[:user])
          flash[:notice] = "Update successful!"
          format.html { redirect_to(@user) }
        else
          format.html { render :new }
        end
      else
        flash[:notice] = "You must own him/her!"
        format.html { redirect_to root_url }
      end
    end
  end
end
