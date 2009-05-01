require 'test_helper'

class MainControllerTest < ActionController::TestCase
  setup :initialize_user
  
  def initialize_user
    @user_id = users(:adios).id
    @user_login = users(:adios).login
  end

  test "Routing" do
    assert_routing '/', { :controller => 'main', :action => 'index' }
    assert_routing({ :method => :post, :path => '/session' }, { :controller => 'main', :action => 'create' })
    assert_routing({ :method => :delete, :path => '/session' }, { :controller => 'main', :action => 'destroy' })
  end

  test "GET /" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select 'form'	
  end
  
  test "login failure" do
  	post :create, { :session => { :login => @user_login, :password => 'tess' } }
    assert_response :success
    assert_nil session['user_id']
    assert_template 'index'
  end
  
  test "login success and logout" do
    post :create, { :session => { :login => @user_login, :password => 'test' } }
    assert_response :redirect
    assert_redirected_to user_path(@user_id)
    assert_equal session['user_id'], @user_id
    assert_equal session['user_login'], @user_login
    
    get :index
    assert_select 'form', false
    
    # logout
    delete :destroy
    assert_response :redirect
    assert_redirected_to root_url
    assert_nil session['user_id']
    
    get :index
    assert_select 'form'
  end
end
