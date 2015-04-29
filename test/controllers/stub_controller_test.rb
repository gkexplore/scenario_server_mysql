require 'test_helper'

class StubControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
