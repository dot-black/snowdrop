class Manager::DiscountsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_set_discount, except:[:index, :new, :create]
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
        format.html { redirect_to manager_discounts_path, notice: "Discount has been successfully created." }
      else
        flash.now.notice = "Discount wasn't created, please check errors below!"
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @discount.update _permitted_discount_params
        format.html { redirect_to manager_discount_path(@discount), notice: "Discount has been successfully updated." }
      else
        flash.now.notice = "Discount wasn't updated, please check errors below!"
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @discount.products.present?
        notice = @discount.destroy ? "Discount has been successfully destroyed." : "Destroy failed!"
        format.html { redirect_to manager_discounts_path, notice: notice }
      else
        format.html { redirect_to manager_discount_path(@discount), notice: "Discount can't be destroyed, because of #{ @discount.products.count } #{'product'.pluralize(@discount.products.count)} involved."}
     end
    end
  end

  def change_appearance
    respond_to do |format|
      if @discount.actual
        @discount.update start_at: nil, end_at: Time.now
        notice = "Discount is not active right now."
      else
        @discount.update start_at: nil, end_at: nil
        notice = "Discount activated."
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
      @discount = Discount.find(params[:id])
    end

    def _permitted_discount_params
      params.require(:discount).permit(:title, :description, :value, :start_at, :end_at)
    end

end
