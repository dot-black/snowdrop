class StoreController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: :index

  def index
    @categories = Category.visible
    _set_cart_line_items
    _set_cart_counter @line_items
  end

  def get_cart_items_count
    _set_cart
    _set_cart_line_items
    _set_cart_counter @line_items
    render json: {
      catr_items_count: @cart_line_items_quantity,
      status: :success
      }
  end

end
