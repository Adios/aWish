require 'test_helper'

class MainControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "get index" do
    get :index
	assert_response :success
	assert_not_nil assigns(:user)
  end
end
