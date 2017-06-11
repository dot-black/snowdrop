class ProductsController < ApplicationController
  before_action :set_product, only: :show
  before_action :set_categories, only: [:index, :show]
  before_action :enusre_product_visible!, only: :show


  def index
    @products = Product.shown.page params[:page]
    filtering_params(params).each do |key, value|
      @products = ( @products.public_send(key, value).page params[:page] )if permitted_value?(value)
    end
    @current_category = current_category
  end

  def show
  end

  private

    def set_categories
      @categories = Category.visible
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def enusre_product_visible!
      redirect_to products_path unless @product.visible
    end

    # def permitted_product_params
    #   params.require(:product).permit(:title, :description, :image, :price)
    # end

    def filtering_params(params)
      params.slice :category
    end

    def permitted_value?(id)
      Category.exists?(id) and Category.find(id).visible
    end

    def current_category
      ( params[:category].present? and permitted_value? params[:category] ) ?  Category.find(params[:category]) : nil
    end
end
