class Manager::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :change_appearance]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(permitted_category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to manager_categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @category.update(permitted_category_params)
        format.html { redirect_to manager_categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    unless ( @category.products.ids & LineItem.products.ids ).any?
      @category.destroy
      respond_to do |format|
        format.html { redirect_to manager_categories_path, notice: 'Category was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      #Add notice
    end
  end

  def change_appearance
    @category.update visible: !@category.visible
    redirect_to manager_categories_path
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def permitted_category_params
      params.require(:category).permit(:title, :description, :image, :price)
    end
end
