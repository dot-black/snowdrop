require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @category_first = categories(:first_visible)
    @product_first = products(:bra)
    @product_second = products(:new_bra)
  end
  test "Check out order" do
    assert_difference 'LineItem.count' do
      visit store_url
      click_on @category_first.title.pluralize(2), match: :first
      click_on @product_first.title, match: :first
      click_on 'Add to cart'
      click_on 'Add to cart'
      visit cart_url
      click_on 'Checkout'
      assert_selector 'h2', text: 'Enter your email'
      fill_in 'Email', with: 'bob@gmail.com'
      click_on 'continue'
      assert_selector 'h2', text: 'Enter your information'
      fill_in 'Name', with: 'Bob'
      fill_in 'Telephone', with: "+1234567890"
      click_on 'continue'
      assert_selector "h2", text: "Leave your comment"
      fill_in 'Comment', with: "It's a gorgeous site, I gonna buy products over here all the time!"
      click_on 'place order'
    end
  end
end
