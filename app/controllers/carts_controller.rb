class CartsController < ApplicationController
  include CurrentCart
  include Categories

  def show
    _set_categories
    _set_cart
    _set_line_items_variables
  end
end
