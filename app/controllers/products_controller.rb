class ProductsController < ApplicationController
  before_action :_set_product, only: :show
  before_action :_set_categories, only: [:index, :show]


  def index
    redirect_to store_path unless @current_category = _current_category
    @products =
      manager_signed_in? ?
        Product.relevant.category(params[:category]).page( params[:page] ) :
        Product.shown.category(params[:category]).page( params[:page] )
  end

  def show
    redirect_to products_path unless _enusre_product_and_category_visible!
  end


  private

  def _set_categories
    @categories = manager_signed_in? ? Category.all : Category.visible
  end

  def _set_product
    @product = Product.find params[:id]
  end

  def _enusre_product_and_category_visible!
    manager_signed_in? or ( @product.visible and @product.category.visible )
  end

  def _category_available?
    Category.exists?(params[:category]) and ( Category.find(params[:category]).visible or manager_signed_in? )
  end

  def _current_category
    ( params[:category].present? and _category_available? ) ?  Category.find(params[:category]) : nil
  end

end
