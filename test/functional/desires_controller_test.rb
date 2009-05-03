require 'test_helper'

class DesiresControllerTest < ActionController::TestCase
  test "routing" do
    assert_routing '/desires', { :controller => 'desires', :action => 'index' }
    assert_routing '/desires/new', { :controller => 'desires', :action => 'new' }
    assert_routing '/desires/1/edit', { :controller => 'desires', :action => 'edit', :id => '1' }
    assert_routing '/desires/1', { :controller => 'desires', :action => 'show', :id => '1' }
    assert_routing({ :method => :post, :path => '/desires' }, { :controller => 'desires', :action => 'create' })
    assert_routing({ :method => :delete, :path => '/desires/1' }, { :controller => 'desires', :action => 'destroy', :id => '1' })
    assert_routing({ :method => :put, :path => '/desires/1' }, { :controller => 'desires', :action => 'update', :id => '1' })
  end

  test "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:desires)
    p @request
  end
  
  test "show" do
    get :show, { :id => '1' }
    assert_response :success
    assert_not_nil assigns(:desire)
  end
  
  test "new" do
    # not logged in
    get :new
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    get :new, nil, { :user_id => '1' }
    assert_response :success
    assert_not_nil assigns(:desire)
  end
  
  test "edit" do
    # not logged in
    get :edit
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    get :edit, { :id => '1' }, { :user_id => '1' }
    assert_response :success
    assert_not_nil assigns(:desire)
  end
  
  test "create" do
    # not logged in
    post :create, { :desire => { } }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    assert_difference 'Desire.count' do
      post :create, { :desire => { } }, { :user_id => '1' }
    end
    assert_response :redirect
    assert_redirected_to desire_path(assigns(:desire))
  end
  
  test "destroy" do
    # not logged in
    delete :destroy, { :id => '1' }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    assert_difference 'Desire.count', -1 do
      delete :destroy, { :id => '1' }, { :user_id => '1' }
    end
    assert_response :redirect
    assert_redirected_to user_path(1)
  end
  
  test "update" do
    # not logged in
    put :update, { :id => '1' }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    assert_no_difference 'Desire.count' do
      put :update, { :id => '1' }, { :user_id => '1' }
    end
    assert_response :redirect
    assert_redirected_to desire_path(assigns(:desire))    
  end
end
