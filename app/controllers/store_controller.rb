class StoreController < ApplicationController
  before_action :_set_cart, :_set_categories
  before_action :_set_line_items_variables, except:[:update, :destroy]
  def index

  end

  def get_cart_items_count
    render json: {
      catr_items_count: @cart_line_items_quantity,
      status: :success
      }
  end

  private
  def _ensure_cart_isnt_empty
    if @cart.line_items.empty?
      flash[:notice] = "Please add something to cart."
      redirect_to store_path
    end
  end

  def _set_cart
    @cart = GetCart.run! session: session
  end

  def _set_categories
    @categories = Category.visible
  end

  def _set_line_items_variables
    @line_items = @cart.line_items
    @total = GetLineItemsTotalAmount.run! line_items: @line_items
    @cart_line_items_quantity = GetLineItemsQuantity.run! line_items: @line_items
  end

end
