class ProductsController < ApplicationController
  before_action :set_product, only: :show
  before_action :enusre_product_visible!, only: :show


  def index
    @products = Product.visible.page params[:page]
    filtering_params(params).each do |key, value|
      @products = ( @products.public_send(key, value).page params[:page] )if permitted_value?(value)
    end
    @current_category = current_category
  end

  def show

  end

  # def new
  #   @product = Product.new
  # end
  #
  # def edit
  # end
  #
  # def create
  #   @product = Product.new(permitted_product_params)
  #
  #   respond_to do |format|
  #     if @product.save
  #       format.html { redirect_to @product, notice: 'Product was successfully created.' }
  #       format.json { render :show, status: :created, location: @product }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  #
  # def update
  #   respond_to do |format|
  #     if @product.update(permitted_product_params)
  #       format.html { redirect_to @product, notice: 'Product was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @product }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # def destroy
  #   @product.destroy
  #   respond_to do |format|
  #     format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

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

    def permitted_value?(value)
      Product.categories.has_key?(value)
    end

    def current_category
      ( params[:category].present? and permitted_value? params[:category] ) ?  params[:category] : "product"
    end
end
