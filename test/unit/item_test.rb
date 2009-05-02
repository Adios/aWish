require 'test_helper'

class ItemTest < ActiveSupport::TestCase  
  self.use_instantiated_fixtures  = true
  
  test "update name" do
    # nil
    @mac.name = nil
    assert !@mac.save
    assert @mac.errors.invalid?('name')
    # blank
    @mac.name = ''
    assert !@mac.save
    # too long
    @mac.name = 'name' * 50 + '1'
    assert !@mac.save
    # correct save
    @mac.name = 'macmac'
    assert @mac.save
    # collision
    assert_nil Item.create(:name => 'MacMac', :price => '123.54').id
  end
  
  test "update price" do
    # zero
    @mac.price = 0
    assert @mac.save
    # negative
    @mac.price = -1
    assert !@mac.save
    assert @mac.errors.invalid?('price')
    # invalid
    @mac.price = '13x45'
    assert !@mac.save
    # nil
    @mac.price = nil
    assert @mac.save
    # blank
    @mac.price = ''
    assert @mac.save
    assert_equal @mac.price, nil
    # correct save
    @mac.price = '123.54'
    assert @mac.save
  end
  
  test "update link" do
    # correct save
    assert @mac.save
    # nil
    @mac.link = nil
    assert @mac.save
    # invalid
    @mac.link = 'adioshttp://'
    assert !@mac.save
    assert @mac.errors.invalid?('link')
    # too long
    @mac.link = 'http://' + 'link' * 64
    assert !@mac.save
    assert_equal "is too long (maximum is 255 characters)", @mac.errors.on(:link)
  end
  
  test "protected attributes" do
    i = Item.new :id => 999999, :name => 'macair'
    assert_nil i.id
    assert i.save
    assert_not_equal 999999, i.id

    i.update_attributes :id => 999999, :name => 'mmmmm'
    assert i.save
    assert_not_equal 999999, i.id
    assert_equal 'mmmmm', i.name
  end
end