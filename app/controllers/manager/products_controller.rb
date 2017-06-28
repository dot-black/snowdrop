class Manager::ProductsController < ApplicationController
  before_action :_set_product, only: [:show, :edit, :update, :destroy, :change_appearance, :archive, :remove_single_image]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @current_category = "All"
    @products = Product.relevant.page params[:page]
    _filtering_params(params).each do |key, value|
      if key.present?
        @products =  @products.public_send(key).page params[:page]
        @current_category =  key.capitalize
      end
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
    @product = Product.new _permitted_product_params
    respond_to do |format|
      if @product.save
        format.html { redirect_to manager_products_path, notice: "Product has been successfully created." }
      else
        flash.now.notice = "Product wasn't created, please check errors below!"
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update _permitted_product_params
        format.html { redirect_to manager_products_path, notice: "Product has been successfully updated." }
      else
        flash.now.notice = "Product wasn't updated, please check errors below!"
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @product.destroy
        format.html { redirect_to manager_products_path, notice: "Product has been successfully destroyed." }
      else
        format.html { redirect_to manager_products_path, notice: "Product hasn't been destroyed!" }
      end
    end
  end

  def archive
    respond_to do |format|
      if @product.update archive: !@product.archive, visible: false
        format.html { redirect_to manager_products_path , notice: "Product #{@product.title } has been archived." }
      else
        format.html { redirect_to manager_products_path , notice: "Product #{@product.title } hasn't been archived!" }
      end
    end
  end

  def change_appearance
    respond_to do |format|
      if @product.update visible: !@product.visible
        format.html { redirect_to manager_products_path, notice: "Product #{@product.title } has become #{@product.visible ? 'visible' : 'invisible' }." }
      else
        format.html { redirect_to manager_products_path , notice: "Product #{@product.title } hasn't change it's appearance!" }
      end
    end
  end

  def remove_single_image
    respond_to do |format|
      if @product.update images: @product.images.tap{ |a| a.delete_at(params[:index].to_i) }
        format.html { redirect_to edit_manager_product_path(@product), notice: "Single image was deleted." }
      else
        format.html { redirect_to edit_manager_product_path(@product), notice: "Single image couldn't be deleted!" }
      end
    end
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
