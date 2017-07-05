require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @category_first = categories(:first_visible)
    @product_first = products(:iphone)
    @product_second = products(:ipad)
  end
  test "Check out order" do
    assert_difference 'LineItem.count' do
      visit store_url
      click_on @category_first.title.pluralize(2)
      click_on @product_first.title
      click_on 'Add to cart'
      visit cart_url
      click_on 'Checkout'
      assert_selector "h2", text: "Checkout"
      fill_in 'Name', with: 'Bob'
      fill_in 'Email', with: 'bob@gmail.com'
      fill_in 'Telephone',with: "+1234567890"
      fill_in 'Comment',with: "It's a gorgeous site, I gonna buy products over here all the time!"
      click_on 'place order'
    end
  end
end
