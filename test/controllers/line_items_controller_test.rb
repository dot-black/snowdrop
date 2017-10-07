require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items :one
    @line_items = [line_items(:one), line_items(:two)]
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale

    test "should create line_item #{locale}" do
      assert_difference 'LineItem.count' do
        post line_items_url(locale: locale), params: { line_item: {
          product_id: products(:bra).id,
          cart_id: carts(:one).id
        }}
      end
    end

    test "should destroy line_item #{locale}" do
      assert_difference 'LineItem.count', -1 do
        delete line_item_url @line_item, locale: locale
      end
    end
  end
end
