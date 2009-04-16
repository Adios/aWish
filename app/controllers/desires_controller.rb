class DesiresController < ApplicationController
  # GET /desires
  # GET /desires.xml
  def index
    @desires = Desire.find_all_by_purchase(false, :order => "priority DESC") + Desire.find_all_by_purchase(true, :order => "priority DESC")

    @total_expenses = Desire.total_expenses
    @total_budgets = Desire.total_budgets
    @tobuy_items = Desire.total_items_tobuy

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @desires }
    end
  end

  # GET /desires/1
  # GET /desires/1.xml
  def show
    @desire = Desire.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @desire }
    end
  end

  # GET /desires/1/edit
  def edit
    @desire = Desire.find(params[:id])
  end

  # POST /desires
  # POST /desires.xml
  def create
    @desire = Desire.new(params[:desire])

    respond_to do |format|
      if @desire.save
        format.text { render :text => 'done.' }
        format.html { redirect_to(@desire) }
        format.xml  { render :xml => @desire, :status => :created, :location => @desire }
      else
        fotmat.text { render :text => 'failed.' }
        format.html { render :action => "new" }
        format.xml  { render :xml => @desire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /desires/1
  # PUT /desires/1.xml
  def update
    @desire = Desire.find(params[:id])

    respond_to do |format|
      if @desire.update_attributes(params[:desire])
        flash[:notice] = 'Desire was successfully updated.'
        format.html { redirect_to(@desire) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @desire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /desires/1
  # DELETE /desires/1.xml
  def destroy
    @desire = Desire.find(params[:id])
    @desire.destroy

    respond_to do |format|
      format.html { redirect_to(desires_url) }
      format.xml  { head :ok }
    end
  end
end
