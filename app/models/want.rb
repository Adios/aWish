class Want < ActiveRecord::Base
	def self.total_expenses
		Want.sum(:price) || BigDecimal("0.0")
	end
  def self.total_budgets
    Want.sum(:price, :conditions => [ "purchase == ?", false ]) || BigDecimal("0.0")
  end
  def self.total_items_tobuy
    Want.find_all_by_purchase(false).size
  end
end
