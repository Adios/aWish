class MainController < ApplicationController
  def index
    @desire = Desire.new
    @desires = Desire.find_all_by_purchase(false, :order => "priority DESC") + Desire.find_all_by_purchase(true, :order => "priority DESC")

	@attr = Desire.new.attributes.keys
	
	@meta = [
	  [ 'Size', @desires.size ],
	  [ 'Expenses', Desire.expenses ], 
	  [ 'Budgets', Desire.budgets ],
	  [ 'Un-achieved', Desire.unachieved ]
	]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @desires }
    end
  end
end
