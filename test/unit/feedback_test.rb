require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  def setup
    @al = feedbacks(:adios_lee)
  end
  
  test "update spent" do
    # nil
    @al.spent = nil
    assert @al.save
    # blank
    @al.spent = ''
    assert @al.save
    assert_equal @al.spent, nil
    # invalid format
    @al.spent = '1a3x'
    assert !@al.save
    # zero
    @al.spent = 0
    assert @al.save
    # negative
    @al.spent = '-13'
    assert !@al.save
    # correct
    @al.spent = '123456'
    assert @al.save
  end
  
  test "update source" do
    # correct save
    assert @al.save
    # nil
    @al.source = nil
    assert @al.save
    # too long
    @al.source = 'http://' + 'source' * 50
    assert !@al.save
    assert_equal "is too long (maximum is 255 characters)", @al.errors.on(:source)
  end
  
  test "update note" do
    # nil
    @al.note = nil
    assert @al.save
    # blank
    @al.note = ''
    assert @al.save
    # too long
    @al.note = 'note' * 256 + '1'
    assert !@al.save
    # correct save
    @al.note = 'macmac'
    assert @al.save
  end
  
  test "protected attributes" do
    f = Feedback.new :id => 999999
    assert_nil f.id
    assert f.save
    assert_not_equal 999999, f.id

    f.update_attributes :id => 999999, :note=> 'hi'
    assert f.save
    assert_not_equal 999999, f.id
    assert_equal 'hi', f.note
  end
end
