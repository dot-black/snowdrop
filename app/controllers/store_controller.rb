class StoreController < ApplicationController
  def index
    _set_categories
    _set_cart_variables
  end

private
  def _set_categories
    @categories = Category.visible
  end

  def _set_cart_variables
    @cart = GetCart.run! session: session
    @total = GetLineItemsTotalAmount.run! line_items: @cart.line_items
    @cart_line_items_quantity = GetLineItemsQuantity.run! line_items: @cart.line_items
  end
end
