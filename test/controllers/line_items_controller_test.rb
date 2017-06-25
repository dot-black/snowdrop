require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
    @line_items = [ line_items(:one), line_items(:two) ]
  end

  test "should create line_item" do
    assert_difference 'LineItem.count' do
      post line_items_url params: { line_item: {
        product_id: products(:iphone).id,
        cart_id: carts(:one).id
      }}
    end
  end

  test "should destroy line_item" do
    assert_difference 'LineItem.count', -1 do
      delete line_item_url @line_item
    end
  end
end
