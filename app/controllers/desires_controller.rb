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
      if not params[:user_id].nil?
        format.json { render :json => { :code => 200, :mesg => 'success', :data => @desires } }
      end
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
      format.json do
        render :json => { 
           :code => 200,
           :mesg => 'success',
           :data => { :desire => @desire, :item => @desire.item, :feedback => @desire.feedback }
        }
      end
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
        format.json { render :json => { :code => 200, :mesg => 'success', :data => { :desire => @desire, :item => @item } } }
      else
        format.html { render :new }
        format.json { render :json => { :code => 400, :mesg => 'failure', :data => { :desire => @desire.errors.full_messages, :item => @item.errors.full_messages } } }
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
          format.json { render :json => { :code => 200, :mesg => 'success', :data => { :desire => params[:desire], :item => params[:item] } } }
        else
          format.html { render :new }
          format.json { render :json => { :code => 400, :mesg => 'failure', :data => { :desire => @desire.errors.full_messages, :item => @item.errors.full_messages } } }
        end
      else
        flash[:notice] = "you must own the resource!"
        format.html { redirect_to root_url }
        format.json { render :json => { :code => 400, :mesg => flash[:notice] } }
      end
    end
  end

  def destroy
    @desire = Desire.find(params[:id])
    
    respond_to do |format|
      if user_owned?(@desire)
        if @desire.destroy
          format.html { redirect_to(user_path(@current_user)) }
          format.json { render :json => { :code => 200, :mesg => 'success', :data => @desire } }
        end
      else
        flash[:notice] = "you must own the resource!"
        format.html { redirect_to root_url }
        format.json { render :json => { :code => 400, :mesg => flash[:notice] } }
      end
    end
  end
end
