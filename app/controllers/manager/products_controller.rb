class Manager::ProductsController < ApplicationController
  before_action :_set_product, only: [:show, :edit, :update, :destroy, :change_appearance, :archive, :remove_single_image]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products = Product.relevant.page params[:page]
    @current_category = "All"
    _filtering_params(params).each do |key, value|
      @products = (@products.public_send(key).page params[:page] ) if key.present?
      @current_category =  key.capitalize
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def archival
    @products = Product.archival.page params[:page]
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(_permitted_product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to manager_products_path  }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(_permitted_product_params)
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
    @product.update archive: !@product.archive, visible: false
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

    def _set_product
      @product = Product.find(params[:id])
    end

    def _permitted_product_params
      params.require(:product).permit(:title, :description, :price, :priority, :index, :category_id, {images: []}, sizes: [])
    end

    def _filtering_params(params)
      params.slice(:visible, :hiden)
    end
end
