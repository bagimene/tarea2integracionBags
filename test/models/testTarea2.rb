require 'test_helper'

class TestTarea2 < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
