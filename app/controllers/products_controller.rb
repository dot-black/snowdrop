class ProductsController < ApplicationController
  include Categories
  include CurrentCart
  before_action :_set_product, only: :show
  before_action :_set_categories, only: [:index, :show]
  before_action :_set_cart, only: [:index, :show]

  def index
    unless @current_category = _current_category
      flash[:notice] = "Category must be present!"
      redirect_to store_path
    end
    _set_cart_line_items
    _set_cart_counter @line_items
    @products = Product.shown.category(params[:category]).page( params[:page] )
      # Manager can see products regardless it visible or hiden
      # manager_signed_in? ?
      #   Product.relevant.category(params[:category]).page( params[:page] ) :
      #   Product.shown.category(params[:category]).page( params[:page] )
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
      # manager_signed_in? or ( @product.visible and @product.category.visible ) # Mmanager can see categories regardless it visible or hiden
      @product.visible and @product.category.visible
    end

    def _category_available?
      # Category.exists?(params[:category]) and ( Category.find(params[:category]).visible or manager_signed_in? ) # Manager can see categories regardless it visible or hiden
      Category.exists?(params[:category]) and Category.find(params[:category]).visible
    end

    def _current_category
      ( params[:category].present? and _category_available? ) ?  Category.find(params[:category]) : nil
    end

end
