require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:first)
    sign_in managers(:first) #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale

    test "should show all users #{locale}" do
      get manager_users_path locale: locale
      assert_response :success
    end


    test "should filter by search query #{locale}" do
      get manager_users_path(search_query: "something", locale: locale), xhr: true
      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "should show user #{locale}" do
      get manager_user_path @user, locale: locale
      assert_response :success
    end
  end
end
