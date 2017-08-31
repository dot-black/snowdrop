require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @cart= carts(:one)
    @line_items = @cart.line_items
  end

  def new_order
    order = Order.new user_id: users(:first).id
  end


  # test "line items should be added to order from cart" do
  #   assert @cart.line_items.count != 0
  #   order = new_order
  #   assert_difference 'order.line_items.count', @line_items.count do
  #     order.add_line_items_from_cart @cart
  #     order.save
  #   end
  #   assert @cart.line_items.count == 0
  # end

  test "line items should be destoyed if order is destroyed" do
    assert_difference 'LineItem.count', -@order.line_items.count do
      @order.destroy
    end
  end

end
