require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  test "should get report" do
    get :report
    assert_response :success
  end

end
