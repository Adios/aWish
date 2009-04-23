class Desire < ActiveRecord::Base
  self.include_root_in_json = false
  
  def self.expenses
    Desire.sum(:price) || BigDecimal("0.0")
  end
  def self.budgets
    Desire.sum(:price, :conditions => [ "purchase == ?", false ]) || BigDecimal("0.0")
  end
  def self.unachieved
    Desire.find_all_by_purchase(false).size
  end
end
