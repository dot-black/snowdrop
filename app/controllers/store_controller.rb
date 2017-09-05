class StoreController < ApplicationController
  before_action :_set_categories
  def index
    _set_line_items_variables
  end

  def get_cart_items_count
    render json: {
      catr_items_count: @cart_line_items_quantity,
      status: :success
    }
  end

  private

  def _set_categories
    @categories = Category.visible
  end

  def _set_line_items_variables
    @cart = GetCart.run! session: session
    @line_items = @cart.line_items
    @total = GetLineItemsTotalAmount.run! line_items: @line_items
    @cart_line_items_quantity = GetLineItemsQuantity.run! line_items: @line_items
  end

end
