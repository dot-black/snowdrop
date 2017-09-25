require 'active_interaction'

class AddLineItemsFromCart < ActiveInteraction::Base
  interface :session
  object :order

  def execute
    cart = GetCart.run! session: session
    cart.line_items.each do |line_item|
      line_item.cart_id = nil
      line_item.actual_price = line_item.product.discount_price
      order.line_items << line_item
    end
  end
end
