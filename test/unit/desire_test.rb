require 'test_helper'

class DesireTest < ActiveSupport::TestCase
  def setup
    @am = desires(:adios_mac)
  end

  test "default value" do
    d = Desire.new
    assert_equal false, d.meet
    assert_equal 0, d.priority
    assert d.save
  end
  
  test "update meet" do
    # nil
    @am.meet = nil
    assert !@am.save
    # blank
    @am.meet = ''
    assert !@am.save
    # other than true/false will be false
    @am.meet = 'pig'
    assert @am.save
    assert_equal @am.meet, false
    # correct
    @am.meet = 't'
    assert @am.save
    assert_equal @am.meet, true
  end
  
  test "update priority" do
    # nil
    @am.priority = nil
    assert !@am.save
    assert @am.errors.invalid?('priority')
    # blank
    @am.priority = ''
    assert !@am.save
    # out of range
    @am.priority = 4
    assert !@am.save
    # correct
    @am.priority = 2
    assert @am.save
  end
  
  test "update budget" do
    # nil
    @am.budget = nil
    assert @am.save
    # blank
    @am.budget = ''
    assert @am.save
    assert_equal @am.budget, nil
    # zero
    @am.budget = '0'
    assert @am.save
    # invalid
    @am.budget = '1x3a'
    assert !@am.save
    # negative
    @am.budget = '-1000'
    assert !@am.save
    # correct
    @am.budget = '1000.0'
    assert @am.save
  end
  
  test "protected attributes" do
    d = Desire.new :id => 999999, :user_id => 123456, :item_id => 123456, :feedback_id => 123456
    assert_nil d.id
    assert_nil d.user_id
    assert_nil d.item_id
    assert_nil d.feedback_id
    assert d.save
    assert_not_equal 999999, d.id
    assert_not_equal 123456, d.user_id
    assert_not_equal 123456, d.item_id
    assert_not_equal 123456, d.feedback_id

    d.update_attributes :id => 999999, :user_id => 123456, :item_id => 123456, :budget => '123', :feedback_id => 123456
    assert d.save
    assert_not_equal 999999, d.id
    assert_not_equal 123456, d.item_id
    assert_not_equal 123456, d.user_id
    assert_not_equal 123456, d.feedback_id
    assert_equal 123, d.budget
  end
end