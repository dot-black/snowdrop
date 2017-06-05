class Manager::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :change_appearance, :archive, :remove_single_image]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products = Product.relevant
    filtering_params(params).each do |key, value|
      @products = @products.public_send(key) if key.present?
    end

  end

  def archival
    @products = Product.archival
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(permitted_product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(permitted_product_params)
        format.html { redirect_to manager_products_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to manager_products_path }
    end
  end

  def archive
    @product.update archive: !@product.archive
    respond_to do |format|
      format.html { redirect_to manager_products_path }
    end
  end

  def change_appearance
    @product.update visible: !@product.visible
    redirect_to manager_products_path
  end

  def remove_single_image
    @product.update images: @product.images.tap{ |a| a.delete_at(params[:index].to_i) }
    redirect_to edit_manager_product_path(@product)
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def permitted_product_params
      params.require(:product).permit(:title, :description, :price, :priority, :index, {images: []}, sizes: [])
    end

    def filtering_params(params)
      params.slice(:visible, :hiden)
    end
end
