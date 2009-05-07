require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "routing" do
    assert_routing '/humans/being', { :controller => 'users', :action => 'new' }
    assert_routing '/humans/1/reborn', { :controller => 'users', :action => 'edit', :id => '1' }
    assert_routing '/humans/1', { :controller => 'users', :action => 'show', :id => '1' }
    assert_routing({ :method => :post, :path => '/humans' }, { :controller => 'users', :action => 'create' })
    assert_routing({ :method => :put, :path => '/humans/1' }, { :controller => 'users', :action => 'update', :id => '1' })
  end

  test "show" do
    get :show, { :id => '1' }
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "edit" do
    # not logged in
    get :edit
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    get :edit, { :id => '1' }, { :user_id => 1 }
    assert_response :success
    assert_not_nil edit_user_path(assigns(:user))
    # not the user
    get :edit, { :id => '1' }, { :user_id => 2 }
    assert_response :redirect
    assert_redirected_to root_url
    assert flash[:notice] 
  end
  
  test "create" do
    # test if u r logged as 'adios', create a new user will reset the session
    assert_difference 'User.count' do
      post :create, { :user => { :login => 'alison', :password => 'alisonisthebest', :password_confirmation => 'alisonisthebest', :email => 'alison@alis.org' } }, { :user_id => 1 }
    end
    assert_response :redirect
    assert_redirected_to assigns(:user)
    assert session[:user_id]
    assert_not_equal session[:user_id], 1
  end
  
  test "update" do
    # not logged in
    put :update, { :id => '1' }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    assert_no_difference 'User.count' do
      put :update, { :id => '1', :user => { :login => 'alison', :password => 'alisonisthebest', :password_confirmation => 'alisonisthebest', :email => 'alison2@alison.org'} }, { :user_id => 1 }
    end
    assert_response :redirect
    assert_redirected_to assigns(:user)
    # not the owner
    assert_no_difference 'Desire.count' do
      put :update, { :id => '1', :user => { :login => 'alison', :password => 'alisonisthebest', :password_confirmation => 'alisonisthebest', :email => 'alison2@alison.org'} }, { :user_id => 2 }
    end
    assert_response :redirect
    assert_redirected_to root_url
    assert flash[:notice]    
  end
end
