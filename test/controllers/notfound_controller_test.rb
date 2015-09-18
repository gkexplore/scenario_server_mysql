require 'test_helper'

class NotfoundControllerTest < ActionController::TestCase
  test "should get notfound" do
    get :notfound
    assert_response :success
  end

end
