require 'test_helper'

class WantsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create want" do
    assert_difference('Want.count') do
      post :create, :want => { }
    end

    assert_redirected_to want_path(assigns(:want))
  end

  test "should show want" do
    get :show, :id => wants(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => wants(:one).to_param
    assert_response :success
  end

  test "should update want" do
    put :update, :id => wants(:one).to_param, :want => { }
    assert_redirected_to want_path(assigns(:want))
  end

  test "should destroy want" do
    assert_difference('Want.count', -1) do
      delete :destroy, :id => wants(:one).to_param
    end

    assert_redirected_to wants_path
  end
end
