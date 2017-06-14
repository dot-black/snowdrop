class ProductsController < ApplicationController
  before_action :_set_product, only: :show
  before_action :_set_categories, only: [:index, :show]
  before_action :_enusre_product_visible!, only: :show


  def index
    @current_category = _current_category
    @products = Product.shown.page params[:page]
    @products = ( @products.category(params[:category]).page params[:page] )if _category_available?
  end

  def show
  end


  private

  def _set_categories
    @categories = Category.visible
  end

  def _set_product
    @product = Product.find params[:id]
  end

  def _enusre_product_visible!
    redirect_to products_path unless @product.visible
  end

  def _category_available?
    Category.exists?(params[:category]) and Category.find(params[:category]).visible
  end

  def _current_category
    ( params[:category].present? and _category_available? ) ?  Category.find(params[:category]) : nil
  end

end
