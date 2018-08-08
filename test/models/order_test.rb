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

  test "should get orders by their status" do
    Order.statuses.keys.each do |status|
      (Order.statuses.keys - [status]).each do |excluded|
        assert Order.filter_status(status).map(&:status).exclude?(excluded)
      end
    end
  end
  test "should search by name or telephone or email" do
    assert Order.search_by_name_or_email_or_telephone(@order.user.email).map(&:id).include?(@order.id)
    assert Order.search_by_name_or_email_or_telephone(@order.user_information.name).map(&:id).include?(@order.id)
    assert Order.search_by_name_or_email_or_telephone(@order.user_information.telephone).map(&:id).include?(@order.id)
  end
end
