class StoreController < ApplicationController
  include CurrentCart
  include Categories

  def index
    _set_cart
    _set_categories
    _set_line_items_variables
  end

  def get_cart_items_count
    _set_cart
    _set_line_items_variables
    render json: {
      catr_items_count: @cart_line_items_quantity,
      status: :success
      }
  end

end
