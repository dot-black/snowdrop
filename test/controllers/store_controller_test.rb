require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should get index #{locale}" do
      get store_path locale: locale
      assert_response :success
    end
  end
end
