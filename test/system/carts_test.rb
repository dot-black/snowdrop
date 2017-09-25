require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "visiting empty cart" do
    visit cart_url
    assert_selector "span", text: "Your shopping_cart is empty"
    click_on 'Go back shoping'
  end
end
