class MainController < ApplicationController
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
end
