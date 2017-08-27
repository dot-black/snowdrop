class ProductsController < StoreController
  def index
    if @current_category = _current_category
      @products = Product.shown.category(@current_category.id).page(params[:page]).per(10)
    else
      flash[:notice] = "Category must be present!"
      redirect_to store_path
    end
  end

  def show
    _set_product
    @current_category = @product.category
    unless _enusre_product_and_category_visible!
      flash[:notice] = "Can't find such product!"
      redirect_to store_path
    end
  end

  private

    def _set_product
      @product = Product.find params[:id]
    end

    def _enusre_product_and_category_visible!
      @product.visible and @product.category.visible
    end

    def _category_available?
      Category.exists?(["lower(title) = ?", params[:category].gsub("_", " ")]) and Category.where('lower(title) = ?', params[:category].gsub("_", " ")).take.visible
    end

    def _current_category
      ( params[:category].present? and _category_available? ) ?  Category.where('lower(title) = ?', params[:category].gsub("_", " ")).take : nil
    end

end
