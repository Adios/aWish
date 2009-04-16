class Desire < ActiveRecord::Base
	def self.total_expenses
		Desire.sum(:price) || BigDecimal("0.0")
	end
  def self.total_budgets
    Desire.sum(:price, :conditions => [ "purchase == ?", false ]) || BigDecimal("0.0")
  end
  def self.total_items_tobuy
    Desire.find_all_by_purchase(false).size
  end
end
