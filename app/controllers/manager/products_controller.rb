class Manager::ProductsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_ensure_product_present, except: [:index, :archival, :new, :create]
  before_action :_set_product_orders, only: :destroy

  layout 'managers/dashboard'

  def index
    _set_categories
    _fetch_current_category if params[:manager_category].present?
    @products = Product.relevant.filter(params.slice(:visible, :hidden, :manager_category)).page params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def archival
    @products = Product.archival.page params[:page]
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new _permitted_product_params
    respond_to do |format|
      if @product.save
        _add_more_images if _permitted_product_images_params.present?
        format.html { redirect_to manager_products_path, notice: t('manager.products.flash.create.success') }
      else
        format.html { render :new }
        flash.now.notice = t('manager.products.flash.create.failure')
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update _permitted_product_params
        _add_more_images if _permitted_product_images_params.present?
        format.html { redirect_to manager_product_path(@product), notice: t('manager.products.flash.update.success') }
      else
        flash.now.notice = t('manager.products.flash.update.failure')
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @product_orders.blank?
        notice =
          if @product.destroy
            t('manager.products.flash.destroy.success')
          else
            t('manager.products.flash.destroy.failure')
          end
        format.html { redirect_to archival_manager_products_path, notice: notice }
      else
        format.html { redirect_to archival_manager_products_path, notice: t('manager.products.flash.destroy.involvement') }
      end
    end
  end

  def archive
    respond_to do |format|
      notice =
        if @product.update(archive: !@product.archive, visible: false)
          if @product.archive
            t('manager.products.flash.archive.archived')
          else
            t('manager.products.flash.archive.restored')
          end
        else
          t('manager.products.flash.archive.failure')
        end
      format.html { redirect_to (@product.archive ? manager_products_path : archival_manager_products_path), notice: notice }
    end
  end

  def change_appearance
    respond_to do |format|
      notice =
        if @product.update(visible: !@product.visible)
          if @product.visible
            t('manager.products.flash.appearance.visible')
          else
            t('manager.products.flash.appearance.invisible')
          end
        else
          t('manager.products.flash.change_appearance.failure')
        end
      format.html { redirect_to manager_products_path, notice: notice }
    end
  end

  def remove_single_image
    respond_to do |format|
      notice =
        if @product.update(images: @product.images.tap { |a| a.delete_at(params[:index].to_i) })
          t('manager.products.flash.remove_single_image.success')
        else
          t('manager.products.flash.remove_single_image.failure')
        end
      format.html { redirect_to edit_manager_product_path(@product), notice: notice }
      format.js
    end
  end

  private

  def _ensure_product_present
    @product = Product.find_by(id: params[:id])
    redirect_to manager_order_path unless @product
  end

  def _permitted_product_params
    params.require(:product).permit :title,
                                    :description,
                                    :price,
                                    :priority,
                                    :index,
                                    :category_id,
                                    sizes: [bra: [], panties: [], standard: []],
                                    translations_attributes: [:id, :attribute_name, :locale, :value]
  end

  def _permitted_product_images_params
    params.require(:product).permit(images: [])
  end

  def _add_more_images
    @product.update images: (@product.images + _permitted_product_images_params[:images])
  end

  def _set_product_orders
    @product_orders = Order.find(LineItem.where(product_id: @product.id).pluck(:order_id))
  end

  def _fetch_current_category
    @current_category = Category.find_by(id: params[:manager_category])
  end

  def _set_categories
    @categories = Category.all
  end
end
