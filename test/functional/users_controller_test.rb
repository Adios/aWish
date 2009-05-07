require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "routing" do
    assert_routing '/humans', { :controller => 'users', :action => 'index' }
    assert_routing '/humans/being', { :controller => 'users', :action => 'new' }
    assert_routing '/humans/1/reborn', { :controller => 'users', :action => 'edit', :id => '1' }
    assert_routing '/humans/1', { :controller => 'users', :action => 'show', :id => '1' }
    assert_routing({ :method => :post, :path => '/humans' }, { :controller => 'users', :action => 'create' })
    assert_routing({ :method => :put, :path => '/humans/1' }, { :controller => 'users', :action => 'update', :id => '1' })
  end

  test "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "show" do
    # not logged in
    get :show, { :id => '1' }
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select 'div.action', false
    # logged in
    get :show, { :id => '1' }, { :user_id => 1 }
    assert_response :success
    assert_select 'div.action'
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
    # create failed
    assert_no_difference 'User.count' do
      post :create, { :user => { :login => 'adios' } }
    end
    assert_response :success
    assert_equal false, assigns(:user).valid?
    # if 'adios' logged in, he creates a new user, system will reset the current session.
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
    assert_no_difference 'User.count' do
      put :update, { :id => '1', :user => { :login => 'alison', :password => 'alisonisthebest', :password_confirmation => 'alisonisthebest', :email => 'alison2@alison.org'} }, { :user_id => 2 }
    end
    assert_response :redirect
    assert_redirected_to root_url
    assert flash[:notice]    
    # the onwer logged in, and enter the wrong data
    assert_no_difference 'User.count' do
      put :update, { :id => '1', :user => {} }, { :user_id => 1 }
    end
    assert_response :success
    assert_equal false, assigns(:user).valid?
  end
end
