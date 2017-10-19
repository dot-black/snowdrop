class Manager::DiscountsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_ensure_discount_present, except:[:index, :new, :create]
  layout 'managers/dashboard'

  def index
    @discounts = Discount.all.page params[:page]
  end

  def show
  end

  def new
    @discount = Discount.new
  end

  def edit
  end

  def create
    @discount = Discount.new _permitted_discount_params
    respond_to do |format|
      if @discount.save
        format.html { redirect_to manager_discounts_path, notice: (t 'manager.discounts.flash.create.success') }
      else
        format.html { render :new }
        flash.now.notice = t 'manager.discounts.flash.create.failure'
      end
    end
  end

  def update
    respond_to do |format|
      if @discount.update _permitted_discount_params
        format.html { redirect_to manager_discount_path(@discount), notice: (t 'manager.discounts.flash.update.success') }
      else
        format.html { render :edit }
        flash.now.notice = t 'manager.discounts.flash.update.failure'
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @discount.products.present?
        notice = @discount.destroy ? (t 'manager.discounts.flash.destroy.success') : (t 'manager.discounts.flash.destroy.success')
        format.html { redirect_to manager_discounts_path, notice: notice }
      else
        format.html { redirect_to manager_discount_path(@discount), notice: (t 'manager.discounts.flash.destroy.involvement') }
     end
    end
  end

  def change_appearance
    respond_to do |format|
      notice = if @discount.actual and @discount.update_attributes start_at: nil, end_at: Time.now
        t 'manager.discounts.flash.change_appearance.invisible'
      elsif not @discount.actual and @discount.update_attributes start_at: nil, end_at: nil
        t 'manager.discounts.flash.change_appearance.visible'
      else
        t 'manager.discounts.flash.change_appearance.failure'
      end
      format.html { redirect_to manager_discount_path(@discount), notice: notice }
    end
  end

  def edit_products
    @products = Product.relevant.page params[:page]
  end

  def update_products
    Product.where(id: @discount.products.ids - [*params[:product_ids]] ).update_all discount_id: nil if @discount.products.present?
    Product.where(id: params[:product_ids]).update_all discount_id: @discount.id

    redirect_to edit_products_manager_discount_path
  end

private

  def _set_discount
    @discount = Discount.find_by_id params[:id]
  end

  def _ensure_discount_present
    redirect_to manager_discounts_path unless params[:id].present? and _set_discount
  end

  def _permitted_discount_params
    params.require(:discount).permit(:title, :description, :value, :start_at, :end_at)
  end

end
