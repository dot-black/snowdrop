require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
    test "visiting empty cart" do
      visit cart_url locale: 'en'
      assert_selector "span", text: "Your shopping_cart is empty"
      click_on 'Go back shopping'
    end
end
