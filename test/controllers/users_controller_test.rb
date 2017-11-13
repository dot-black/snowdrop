require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @new_user = User.new email: "new@email.com"
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should create user #{locale}" do
      assert_difference('User.count') do
        _set_user @new_user, locale
      end
    end
    test "should visit new user page #{locale}" do
      get users_url locale: locale
      assert_response :success
    end
  end
end
