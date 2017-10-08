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
  end
end
