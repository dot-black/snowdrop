class ProductsController < StoreController
  def index
    unless params[:category].present?
      flash[:notice] = "Category must be present!"
      redirect_to store_path
    else
      _set_category
      unless @current_category.present? and @current_category.visible
        flash[:notice] = "Category is not avalible"
        redirect_to store_path
      else
        @products = Product.shown.category(@current_category.id).page(params[:page]).per(10)
      end
    end
  end

  def show
    _set_product
    @current_category = @product.category
    unless @product.visible and @product.category.visible
      flash[:notice] = "Can't find such product!"
      redirect_to store_path
    end
  end

  private

    def _set_product
      @product = Product.find params[:id]
    end

    def _set_category
      @current_category = FetchCategory.run!(category_parameter: params[:category])
    end
end
