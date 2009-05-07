require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  test "routing" do
    assert_routing '/items', { :controller => 'items', :action => 'index' }
    assert_routing '/items/1', { :controller => 'items', :action => 'show', :id => '1' }
    assert_routing({ :method => :post, :path => '/items/1/want' }, { :controller => 'items', :action => 'want', :id => '1' })
  end
  
  test "index" do
    get :index
    assert assigns(:items)
    assert_response :success
  end
  
  test "show" do
    # not login yet
    get :show, { :id => 1 }
    assert assigns(:item)
    assert_response :success
    assert_select 'div.action', false
    # logged in
    get :show, { :id => 1 }, { :user_id => 1 }
    assert_response :success
    assert_select 'div.action'
  end
  
  test "want" do
    # not login yet
    post :want, { :id => 2 }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    assert_difference 'Desire.count' do
      post :want, { :id => 2 }, { :user_id => 2 }
    end
    assert_response :redirect
  end
end
