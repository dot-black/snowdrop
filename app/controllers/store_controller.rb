class StoreController < ApplicationController
  before_action :_set_categories,except: [:update, :destroy]
  before_action :_set_line_items_variables,except: [:create, :update, :destroy]
  def index
  end

  def get_cart_items_count
    render json: {
      catr_items_count: @cart_line_items_quantity,
      status: :success
    }
  end

  def update_locale
    session[:locale] = params[:new_locale]
    redirect_to store_path
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
