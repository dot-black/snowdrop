class Manager::CategoriesController < ApplicationController
  before_action :_set_category, only: [:show, :edit, :update, :destroy, :change_appearance, :destroy]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    _set_categories
  end

  def show
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
        format.html { render :new, notice: "Category wasn't created, please check errors below" }
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
        format.html { render :edit, notice: "Category wasn't updated, please check errors below"  }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      ivolved_products = @category.products.ids & LineItem.all.map(&:product_id)
      unless ivolved_products.any?
        @category.destroy
        format.html { redirect_to manager_categories_path, notice: "Category was successfully destroyed." }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to manager_categories_path, notice: "Category can't be destroyed, there are #{ ivolved_products.count } #{'product'.pluralize(ivolved_products.count)} involved."}
      end
    end
  end

  def change_appearance
    _set_categories
    respond_to do |format|
      if @category.update visible: !@category.visible
        format.html { redirect_to manager_categories_path, notice: "Category '#{@category.title}' is #{@category.visible ? "visible" : "invisible"} now." }
      else
        format.html { redirect_to manager_categories_path, notice: "Category's appearance wasn't changed." }
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

    def _permitted_category_params
      params.require(:category).permit(:title, :image)
    end
end
