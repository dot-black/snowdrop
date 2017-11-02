require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should create user #{locale}" do
      assert_difference('User.count') do
        post users_url(locale: locale), params: {
          user: {
            email: 'test@email.com',
          }
        }
      end  
    end
    test "should visit new user page #{locale}" do
      get users_url locale: locale
      assert_response :success
    end
  end
end
