require 'test_helper'

class DesiresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:desires)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create desire" do
    assert_difference('Desire.count') do
      post :create, :desire => { }
    end

    assert_redirected_to desire_path(assigns(:desire))
  end

  test "should show desire" do
    get :show, :id => desires(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => desires(:one).to_param
    assert_response :success
  end

  test "should update desire" do
    put :update, :id => desires(:one).to_param, :desire => { }
    assert_redirected_to desire_path(assigns(:desire))
  end

  test "should destroy desire" do
    assert_difference('Desire.count', -1) do
      delete :destroy, :id => desires(:one).to_param
    end

    assert_redirected_to desires_path
  end
end
