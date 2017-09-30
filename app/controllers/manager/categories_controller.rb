class Manager::CategoriesController < ApplicationController
  before_action :authenticate_manager!
  before_action :_set_category, only: [:edit, :update, :destroy, :change_appearance]
  before_action :_set_category_products, only: :edit
  before_action :_set_category_orders, only: [:edit, :destroy]
  layout 'managers/dashboard'

  def index
    _set_categories
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new _permitted_category_params

    respond_to do |format|
      if @category.save
        format.html { redirect_to manager_categories_path, notice: (t 'manager.categories.flash.create.success') }
      else
        format.html { render :new }
        flash.now.notice = t 'manager.categories.flash.create.failure'
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(_permitted_category_params)
        format.html { redirect_to manager_categories_path, notice: (t 'manager.categories.flash.update.success') }
      else
        format.html { render :edit }
        flash.now.notice = t 'manager.categories.flash.update.failure'
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @category_orders.any?
        notice = @category.destroy ? (t 'manager.categories.flash.destroy.success') : (t 'manager.categories.flash.destroy.failure')
        format.html { redirect_to manager_categories_path, notice: notice }
        format.js
      else
        format.html { redirect_to manager_categories_path, notice: (t 'manager.categories.flash.destroy.involvement') }
      end
    end
  end

  def change_appearance
    respond_to do |format|
      if @category.update visible: !@category.visible
        format.html { redirect_to manager_categories_path, notice: @category.visible ?  (t 'manager.categories.flash.change_appearance.visible') : (t 'manager.categories.flash.change_appearance.invisible') }
      else
        format.html { redirect_to manager_categories_path, notice: (t 'manager.categories.flash.change_appearance.failure') }
      end
    end
  end

  private

    def _set_category
      @category = Category.find(params[:id])
    end

    def _set_categories
      @categories = Category.all
    end

    def _set_category_orders
      @category_orders = Order.find(LineItem.where(product_id: @category.products.ids).map(&:order_id))
    end

    def _set_category_products
      @category_products = @category.products
    end

    def _permitted_category_params
      params.require(:category).permit(:title, :slug, :image)
    end
end
