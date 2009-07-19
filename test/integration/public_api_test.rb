require 'test_helper'
require 'json'

class PublicApiTest < ActionController::IntegrationTest
  fixtures :all
  
  def setup
    @header = { 'Accept' => 'application/json' }
  end

  test "GET people/1/desires" do
    get 'people/1/desires', nil, @header
    assert_response :success
    assert_json_response 200
    assert_equal users(:adios).desires.size, @json['data'].size
  end
  
  test "GET desires/1" do
    get 'desires/1', nil, @header
    assert_response :success
    assert_json_response 200
    assert @json['data'].has_key?('item')
    assert @json['data'].has_key?('desire')
    assert @json['data'].has_key?('feedback')
  end

  test "POST /desires" do
    # authenticated reqeusts
    login_as_adios
    # create new one should pass
    assert_difference 'Desire.count' do
      post '/desires', { :item => { :name => 'test6' } }, @header
    end
    assert_json_response 200
    assert_equal 'test6', @json['data']['item']['name']
    # create the same one should fail
    assert_no_difference 'Desire.count' do
      post '/desires', { :item => { :name => 'test6'} }, @header
    end
    assert_json_response 400
    assert assigns(:item).errors.full_messages, @json['data']['item']

    reset!
    # non-authenticated requests 
    assert_no_difference 'Desire.count' do
      post '/desires', { :item => { :name => 'alohaaloha' } }, @header
    end
    assert_redirected_to root_url
  end
  
  test "PUT /desires/1" do
    # authenticated reqeusts
    login_as_adios
    # update attributes should pass
    assert_no_difference 'Desire.count' do
      put '/desires/1', { :desire => { :meet => true, :priority => 3 } }, @header
    end
    assert_json_response 200
    assert_equal desires(:adios_mac).meet.to_json, @json['data']['desire']['meet']
    assert_equal desires(:adios_mac).priority.to_json, @json['data']['desire']['priority']
    # update invalid data should fail
    assert_no_difference 'Desire.count' do
      put '/desires/1', { :desire => { :priority => 100 } }, @header
    end
    assert_json_response 400
    assert_equal assigns(:desire).errors.full_messages, @json['data']['desire']
    # update not-owned one should fail
    assert_no_difference 'Desire.count' do
      put '/desires/3', { :desire => { :priority => 1 } }, @header
    end
    assert_json_response 400
    assert_equal flash[:notice], @json['mesg']
    
    reset!
    # non-authenticated requests 
    assert_no_difference 'Desire.count' do
      put '/desires/1', { :desire => { :priority => 1 } }, @header
    end
    assert_redirected_to root_url
  end
  
  test "DELETE /desires/1" do
    # authenticated reqeusts
    login_as_adios
    # delete one
    assert_difference 'Desire.count', -1 do
      delete '/desires/1', nil, @header
    end
    assert_json_response 200
    assert @json['data']
    # delete not-owned one should fail
    assert_no_difference 'Desire.count' do
      delete '/desires/3', nil, @header
    end
    assert_json_response 400
    assert_equal flash[:notice], @json['mesg']
    
    reset!
    # non-authenticated requests 
    assert_no_difference 'Desire.count' do
      delete '/desires/1', nil, @header
    end
    assert_redirected_to root_url
  end
   
  private 
  
  def login_as_adios
    get '/'
    assert_equal 200, status
    post_via_redirect '/session', :session => { :login => 'adios', :password => 'testtest' }
    assert_equal 200, status
    assert_equal user_path(users(:adios)), path   
  end
  
  def assert_json_response code
    assert_response :success
    @json = JSON.parse @response.body
    assert_equal @json['code'], code
  end
end
