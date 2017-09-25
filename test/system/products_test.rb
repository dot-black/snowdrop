require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @category_first = categories(:first_visible)
    @product_first = products(:bra)
    @product_second = products(:new_bra)
  end
  test "Check product view" do
    visit store_url
    assert_selector "a", text: @category_first.title.pluralize(2)
    click_on @category_first.title.pluralize(2), match: :first
    assert_selector ".product-basic-title", text: @product_first.title
    assert_selector ".product-basic-title", text: @product_second.title
    assert_selector "a", text: @category_first.title.pluralize(2)
    click_on @product_first.title, match: :first
    assert_selector "h1", text: @product_first.title
    assert_selector "span", text: "$#{@product_first.price}"
    assert_selector "select", text: @product_first.sizes.values.first.join(" ")
    assert_selector "p", text: @product_first.description
  end
end
