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
        format.html { redirect_to manager_categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, notice: "Category wasn't created, please check errors below!" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(_permitted_category_params)
        format.html { redirect_to manager_categories_path, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, notice: "Category wasn't updated, please check errors below!"  }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @category_orders.any?
        notice = @category.destroy ? "Category was successfully destroyed." : "Category wasn't destroyed."
        format.html { redirect_to manager_categories_path, notice: notice }
        format.js
      else
        format.html { redirect_to manager_categories_path, notice: "Category can't be destroyed, because of #{ @category_orders.count } #{'order'.pluralize(@category_orders.count)} involved."}
      end
    end
  end

  def change_appearance
    respond_to do |format|
      if @category.update visible: !@category.visible
        format.html { redirect_to manager_categories_path, notice: "Category '#{@category.title}' is #{@category.visible ? "visible" : "invisible"} now." }
      else
        format.html { redirect_to manager_categories_path, notice: "Change appearance failed!" }
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
      params.require(:category).permit(:title, :image)
    end
end
