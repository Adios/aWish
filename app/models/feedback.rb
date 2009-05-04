class Feedback < ActiveRecord::Base
  has_one :desire, :validate => true
  
  validates_numericality_of :spent, :allow_nil => true, :if => Proc.new {|i| i.desire and i.desire.meet }, :greater_than_or_equal_to => 0
  validates_length_of :note, :maximum => 1024, :allow_nil => true
  validates_length_of :source, :maximum => 255, :allow_nil => true
  
  attr_protected :id
end
