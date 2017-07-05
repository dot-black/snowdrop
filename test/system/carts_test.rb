require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "visiting empty cart" do
    visit cart_url
    assert_selector "span", text: "(0 items)"
    click_on 'Checkout'
    assert_selector "#toast-container", text: "Please add something to cart"
  end
end
