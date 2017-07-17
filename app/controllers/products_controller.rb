class ProductsController < ApplicationController
  include Categories
  include CurrentCart
  before_action :_set_product, only: :show
  before_action :_set_categories, only: [:index, :show]
  before_action :_set_cart, only: [:index, :show]

  def index
    if @current_category = _current_category
      _set_cart_line_items
      _set_cart_counter @line_items
      @products = Product.shown.category(@current_category.id).page( params[:page] )
    else
      flash[:notice] = "Category must be present!"
      redirect_to store_path
    end
  end

  def show
    unless _enusre_product_and_category_visible!
      flash[:notice] = "Can't find such product!"
      redirect_to store_path
    end
    _set_cart_line_items
    _set_cart_counter @line_items
  end

  private

    def _set_product
      @product = Product.find params[:id]
    end

    def _enusre_product_and_category_visible!
      @product.visible and @product.category.visible
    end

    def _category_available?
      Category.exists?(["lower(title) = ?", params[:category]]) and Category.where('lower(title) = ?', params[:category]).take.visible
    end

    def _current_category
      ( params[:category].present? and _category_available? ) ?  Category.where('lower(title) = ?', params[:category]).take : nil
    end

end
