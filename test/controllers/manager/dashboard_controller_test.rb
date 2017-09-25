require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in managers(:first) #Login as manager
  end

  test "should show index" do
    get manager_dashboard_path
    assert_response :success
    assert_equal "index", @controller.action_name
  end


end
