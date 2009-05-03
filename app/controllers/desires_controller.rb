class DesiresController < ApplicationController
  before_filter :login_required, :except => %w(index show)

  def index
    @desires = Desire.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @desire = Desire.new
  end
  
  def edit
    @desire = Desire.find(params[:id])
  end
  
  def show
    @desire = Desire.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @desire = Desire.new(params[:desire])

    respond_to do |format|
      if @desire.save
        format.html { redirect_to(@desire) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @desire = Desire.find(params[:id])

    respond_to do |format|
      if @desire.update_attributes(params[:desire])
        format.html { redirect_to(@desire) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @desire = Desire.find(params[:id])
    @desire.destroy

    respond_to do |format|
      format.html { redirect_to(user_path(@current_user)) }
    end
  end
end
