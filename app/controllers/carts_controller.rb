class CartsController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: :show

  def show
    _set_cart_line_items
    _set_cart_total_amount @line_items
    _set_cart_counter @line_items
  end
end
