class DesiresController < ApplicationController
  # GET /desires
  def index
    all
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

  # POST /desires
  # POST /desires.xml
  def create
    @desire = Desire.new(params[:desire])

    respond_to do |format|
      if @desire.save
	    flash[:notice] = 'Desire was successfully created.'
        format.json { render :json => { 'path' => desire_path(@desire), 'status' => 1, 'message' => 'created successfully.' } }
        format.html { redirect_to(@desire) }
        format.xml  { render :xml => @desire, :status => :created, :location => @desire }
      else
        fotmat.json { render :json => { 'status' => 0, 'message' => 'created failed.' } }
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
	    format.json { render :json => { 'status' => 1, 'message' => 'updated successfully.' } }
        format.html { redirect_to(@desire) }
        format.xml  { head :ok }
      else
	    format.json { render :json => { 'status' => 0, 'message' => 'updated failed.' } }
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
  
  private
  
  def all
    @desires = Desire.all
    
    response = Array.new
    @desires.each do |d|
      response[d.id] = d
    end
  
    respond_to do |format|
      format.json { render :json => response.to_json(:except => [ "note" ]) }
    end
  end
end
