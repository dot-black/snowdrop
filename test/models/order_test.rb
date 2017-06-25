require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @cart= carts(:one)
    @line_items = @cart.line_items

  end

  def new_order
    Order.new(
      name: "Daniel Defoe",
      email: "daniel.defoe@example.com",
      telephone: "+357233423453",
      comment: "Superb!"
    )
  end

  test "order should not be created without name" do
    order = new_order
    order.name = ""
    assert order.invalid?
    order.errors[:name]
    order.name = "Daniel Defoe"
    assert order.valid?
  end

  test "order can not be created without correct email" do
    order = new_order
    order.email = ""
    assert order.invalid?
    order.errors[:email]
    order.email = "231.dsd"
    assert order.invalid?
    order.errors[:email]
    order.email = "ddfs@."
    assert order.invalid?
    order.errors[:email]
    order.email = "daniel.defoe@gmail.com"
    assert new_order.valid?
  end


  test "order can not be created without correct telephone" do
    order = new_order
    order.telephone = ""
    assert order.invalid?
    order.errors[:telephone]
    order.telephone = "5345"
    assert order.invalid?
    order.errors[:telephone]
    order.telephone = "5345434534534435"
    assert order.invalid?
    order.errors[:telephone]
    order.telephone = "380631001010"
    assert order.valid?
  end
  test "line items should be added to order from cart" do
    assert @cart.line_items.count != 0
    order = new_order
    assert_difference 'order.line_items.count', @line_items.count do
      order.add_line_items_from_cart @cart
      order.save
    end
    assert @cart.line_items.count == 0
  end

  test "line items should be destoyed if order is destroyed" do
    assert_difference 'LineItem.count', -@order.line_items.count do
      @order.destroy
    end
  end



end
