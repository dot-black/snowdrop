class StoreController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: :index

  def index
    # @categories = manager_signed_in? ? Category.all : Category.visible #Manager can see categories regardles it visible or hiden
    @categories = Category.visible
    _set_cart_line_items
    _set_cart_counter @line_items
  end

end
