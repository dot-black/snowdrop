require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts :one
  end
  
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show empty cart #{locale}" do
      get cart_url @cart, locale: locale
      assert_response :success
    end
  end
end
