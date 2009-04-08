class Want < ActiveRecord::Base
	def self.total_expenses
		Want.sum(:price) || BigDecimal("0.0")
	end
end
