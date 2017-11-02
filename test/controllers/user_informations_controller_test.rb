require 'test_helper'

class UserInformationsControllerTest < ActionDispatch::IntegrationTest
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should create information #{locale}" do
      post users_url(locale: locale), params: {
        user: {
          email: 'test@email.com',
        }
      }
      assert_difference('UserInformation.count') do
        post user_informations_url(locale: locale), params: {
          user_information: {
            name: 'some name',
            telephone: '380635444849',
          }
        }
      end
    end
    test "should redirect to new user if user don't exist #{locale}" do
      get user_informations_url(locale: locale)
      assert_response :redirect
    end
    test "should visit new user_information page if user exist#{locale}" do
      _set_user @user, locale
      get user_informations_url(locale: locale)
      assert_response :success
    end
  end
end
