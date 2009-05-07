class ItemsController < ApplicationController
  before_filter :login_required, :only => %(want)
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find(params[:id])
    @desire = Desire.new

    respond_to do |format|
      format.html
    end
  end
  
  def want
    item = Item.find(params[:id])
    
    respond_to do |format|
      if item.nil?
        format.html { redirect_to root_url }
      else
        desire = Desire.new
        desire.item = item
        desire.user = @current_user
        
        if desire.save
          format.html { redirect_to edit_desire_path(desire) }
        else
          flash[:error] = 'some errors occured.'
          format.html { redirect_to item }
        end
      end
    end
  end
end
