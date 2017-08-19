class Manager::ProductsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_set_product, except:[:index, :archival,:new, :create]
  before_action :_set_product_orders, only: :destroy

  layout 'managers/dashboard'

  def index
    @current_category = "all"
    @products = Product.relevant.page params[:page]
    _filtering_params(params).each do |key, value|
      if key.present?
        @products =  @products.public_send(key,value).page params[:page]
        @current_category =  key
        @current_id = value
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
        _add_more_images if _permitted_product_images_params.present?
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
        _add_more_images if _permitted_product_images_params.present?
        format.html { redirect_to manager_product_path(@product), notice: "Product has been successfully updated." }
      else
        flash.now.notice = "Product wasn't updated, please check errors below!"
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @product_orders.present?
        notice = @product.destroy ? "Product has been successfully destroyed." : "Destroy failed!"
        format.html { redirect_to archival_manager_products_path, notice: notice }
      else
        format.html { redirect_to archival_manager_products_path, notice: "Product can't be destroyed, because of #{ @product_orders.count } #{'order'.pluralize(@product_orders.count)} involved."}
     end
    end
  end

  def archive
    respond_to do |format|
      notice = ( @product.update archive: !@product.archive, visible: false ) ? "Product #{@product.title } has been #{@product.archive ? 'archived' : 'restored'}." : "Archive failed!"
      format.html { redirect_to (@product.archive ? manager_products_path : archival_manager_products_path), notice: notice }
    end
  end

  def change_appearance
    respond_to do |format|
      notice = ( @product.update visible: !@product.visible ) ? "Product '#{@product.title }' has become #{@product.visible ? 'visible' : 'invisible' }." : "Change apperance failed"
      format.html { redirect_to manager_products_path, notice: notice }
    end
  end

  def remove_single_image
    respond_to do |format|
      notice = ( @product.update images: @product.images.tap{ |a| a.delete_at(params[:index].to_i) } ) ? "Single image was deleted." : "Remove single image failed"
      format.html { redirect_to edit_manager_product_path(@product), notice: notice}
      format.js
    end
  end


  private

    def _set_product
      @product = Product.find(params[:id])
    end

    def _permitted_product_params
      params.require(:product).permit(:title, :description, :price, :priority, :index, :category_id, sizes:[bra:[], panties:[], standard:[]])
    end

    def _filtering_params(params)
      params.slice(:visible, :hidden, :manager_category)
    end

    def _permitted_product_images_params
      params.require(:product).permit({images: []})
    end

    def _add_more_images
      @product.update images: (@product.images + _permitted_product_images_params[:images])
    end

    def _set_product_orders
      @product_orders = Order.find(LineItem.where(product_id: @product.id).map(&:order_id))
    end

end
