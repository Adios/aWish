class DesiresController < ApplicationController
  before_filter :login_required, :except => %w(index show)

  def index
    if params[:user_id].nil?
      @desires = Desire.all :order => "updated_at DESC"
    else
      @desires = User.find(params[:user_id]).desires
    end

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @desire = Desire.new
    @item = Item.new
  end
  
  def edit
    @desire = Desire.find(params[:id])
    
    if user_owned?(@desire)
      @item = Item.find(@desire.item)
      render :new
    else
      flash[:notice] = "you must own the resource!"
      redirect_to root_url
    end
  end
  
  def show
    @desire = Desire.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @desire = Desire.new(params[:desire])
    @item = Item.new(params[:item])
    
    @desire.user = @current_user
    @desire.item = @item

    respond_to do |format|
      if @item.save and @desire.save
        format.html { redirect_to(@desire) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @desire = Desire.find(params[:id])
    
    respond_to do |format| 
      if user_owned?(@desire)
        @item = @desire.item
        if @item.update_attributes(params[:item]) and @desire.update_attributes(params[:desire])
          format.html { redirect_to(@desire) }
        else
          format.html { render :action => "edit" }
        end
      else
        flash[:notice] = "you must own the resource!"
        format.html { redirect_to root_url }
      end
    end
  end

  def destroy
    @desire = Desire.find(params[:id])
    
    respond_to do |format|
      if user_owned?(@desire)
        if @desire.destroy
          format.html { redirect_to(user_path(@current_user)) }
        end
      else
        flash[:notice] = "you must own the resource!"
        format.html { redirect_to root_url }
      end
    end
  end
end
