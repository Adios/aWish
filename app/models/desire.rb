class Desire < ActiveRecord::Base
  belongs_to :feedback
  belongs_to :user
  belongs_to :item
  
  validates_inclusion_of :meet, :in => [true, false]
  validates_inclusion_of :priority, :in => 0..3
  validates_numericality_of :budget, :allow_nil => true, :greater_than_or_equal_to => 0

  attr_protected :id, :user_id, :item_id, :feedback_id
end
