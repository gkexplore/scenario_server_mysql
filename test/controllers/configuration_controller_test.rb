require 'test_helper'

class ConfigurationControllerTest < ActionController::TestCase
  test "should get config" do
    get :config
    assert_response :success
  end

end
