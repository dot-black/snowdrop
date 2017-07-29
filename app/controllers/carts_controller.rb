class CartsController < ApplicationController
  include CurrentCart
  include Categories

  def show
    _set_categories
    _set_cart
    _set_cart_line_items
    _set_cart_total_amount @line_items
    _set_cart_counter @line_items
  end
end
