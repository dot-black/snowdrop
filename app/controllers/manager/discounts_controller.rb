class Manager::DiscountsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_ensure_discount_present, except: [:index, :new, :create]
  layout 'managers/dashboard'

  def index
    @discounts = Discount.all.page params[:page]
  end

  def show; end

  def new
    @discount = Discount.new
  end

  def edit; end

  def create
    @discount = Discount.new _permitted_discount_params
    respond_to do |format|
      if @discount.save
        format.html { redirect_to manager_discounts_path, notice: t('manager.discounts.flash.create.success') }
      else
        flash.now.notice = t('manager.discounts.flash.create.failure')
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @discount.update _permitted_discount_params
        format.html { redirect_to manager_discount_path(@discount), notice: t('manager.discounts.flash.update.success') }
      else
        flash.now.notice = t 'manager.discounts.flash.update.failure'
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @discount.products.blank?
        notice =
          if @discount.destroy
            t('manager.discounts.flash.destroy.success')
          else
            t('manager.discounts.flash.destroy.failure')
          end
        format.html { redirect_to manager_discounts_path, notice: notice }
      else
        format.html { redirect_to manager_discount_path(@discount), notice: t('manager.discounts.flash.destroy.involvement') }
      end
    end
  end

  def change_appearance
    respond_to do |format|
      notice =
        if @discount.actual && @discount.update(start_at: nil, end_at: Time.now)
          t('manager.discounts.flash.change_appearance.invisible')
        elsif !@discount.actual && @discount.update(start_at: nil, end_at: nil)
          t('manager.discounts.flash.change_appearance.visible')
        else
          t('manager.discounts.flash.change_appearance.failure')
        end
      format.html { redirect_to manager_discount_path(@discount), notice: notice }
    end
  end

  def edit_products
    @products = Product.relevant.page params[:page]
  end

  def update_products
    if @discount.products.present?
      Product.where(id: @discount.products.ids - [*params[:product_ids]]).update_all(discount_id: nil)
    end
    Product.where(id: params[:product_ids]).update_all(discount_id: @discount.id)
    redirect_to edit_products_manager_discount_path
  end

  private

  def _ensure_discount_present
    @discount = Discount.find_by(id: params[:id])
    redirect_to manager_discounts_path unless @discount
  end

  def _permitted_discount_params
    params.require(:discount).permit(:title, :description, :value, :start_at, :end_at)
  end
end
