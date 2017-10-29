class ProductsController < StoreController
  before_action :_set_cart_variables, :_set_categories

  def index
    unless params[:category].present? and _set_category and @current_category.visible
      redirect_to store_path, notice: t('products.flash.index.missing_category')
    else
      @products = Product.shown.by_category(@current_category.id).page(params[:page])
    end
  end

  def show
    unless params[:id].present? and _set_product and @product.visible and @product.category.visible
      redirect_to store_path, notice: t('products.flash.show.missing_product')
    else
      @current_category = @product.category
    end
  end

private

  def _set_product
    @product = Product.find_by_id params[:id]
  end

  def _set_category
    @current_category = FetchCategory.run!(category_parameter: params[:category])
  end
end
