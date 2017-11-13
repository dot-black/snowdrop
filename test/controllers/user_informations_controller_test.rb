require 'test_helper'

class UserInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :first
    @new_user_information = UserInformation.new name: 'Ronald McDonald', telephone: '380 63 4543 34 43'
  end

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should create information #{locale}" do
      _set_user @user, locale
      assert_difference('UserInformation.count') do
        _set_user_information @new_user_information, locale
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
