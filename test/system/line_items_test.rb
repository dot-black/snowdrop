require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  setup do
    @category_first = categories(:first_visible)
    @product_first = products(:bra)
    @product_second = products(:new_bra)
  end
  test "check counters and total amount" do
    visit store_url locale: 'en'
    #Go to first product
    click_on @category_first.title, match: :first
    click_on @product_first.title, match: :first
    #2 times add first product
    2.times do |time|
      click_on 'Add to cart'
      sleep 1
      assert_selector ".cart-badge", text: "#{time + 1}"
    end
    #Go to second product
    click_on @category_first.title, match: :first
    sleep 1
    click_on @product_second.title, match: :first
    #Add second product with first size and check cart badge
    click_on 'Add to cart'
    assert_selector ".cart-badge", text: 3
    #Add second product with second size and check cart badge
    find('#line_item_size_bra').find(:xpath, 'option[2]').select_option
    click_on 'Add to cart'
    assert_selector ".cart-badge", text: 4
    #Go to cart check line items count and total amount
    visit cart_url locale: 'en'
    assert_selector "span", text: "3 items"
    assert_selector ".cart-total-amount span strong", text: "Total: ₴#{((@product_first.discount_price + @product_second.discount_price) * 2).round 2}"
    #Reduce amount of first product by 1 and check cart badge
    find("td", text: @product_first.title).first(:xpath, './/..').find('.minus-button').click
    assert_selector ".cart-badge", text: 3
    #Check total amount
    assert_selector ".cart-total-amount span strong", text: "Total: ₴#{(@product_first.discount_price + 2 * @product_second.discount_price).round 2}"
    #Check if there is no link for reducing amount, when it equal to 1
    find("td", text: @product_first.title).first(:xpath, './/..').has_no_link? '.minus-button'
    #Increase amount of first product by 1 and check cart badge
    find("td", text: @product_first.title).first(:xpath, './/..').find('.plus-button').click
    assert_selector ".cart-badge", text: 4
    #Check total amount
    assert_selector ".cart-total-amount span strong", text: "Total: ₴#{((@product_first.discount_price + @product_second.discount_price) * 2).round 2}"
    #Check if link for reduceing amount is appear
    find("td", text: @product_first.title).first(:xpath, './/..').has_link? '.minus-button'
    #Check if checkout button is working
    click_on 'Checkout'
    assert_selector "h2", text: "Enter your email"
  end
end
