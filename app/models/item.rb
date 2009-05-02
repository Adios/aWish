class Item < ActiveRecord::Base
  has_many :desires
  has_many :users, :through => :desires
  has_many :feedbacks, :through => :desires
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :price, :allow_nil => true, :greater_than_or_equal_to => 0
  validates_format_of :link, :allow_nil => true, :with => %r|\Ahttp://.*\Z|i
  validates_length_of :name, :maximum => 200
  validates_length_of :link, :maximum => 255, :allow_nil => true
  
  attr_protected :id
end