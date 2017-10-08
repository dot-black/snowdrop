require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in managers(:first) #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show index #{locale}" do
      get manager_dashboard_path locale: locale
      assert_response :success
      assert_equal "index", @controller.action_name
    end
  end
end
