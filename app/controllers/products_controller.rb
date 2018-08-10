class ProductsController < StoreController
  before_action :_set_cart_variables, :_set_categories

  def index
    if params[:category].present? && _set_category && @current_category.visible
      @products = Product.shown.by_category(@current_category.id).page(params[:page])
    else
      redirect_to store_path, notice: t('products.flash.index.missing_category')
    end
  end

  def show
    if _set_product && @product.visible && @product.category.visible
      @current_category = @product.category
    else
      redirect_to store_path, notice: t('products.flash.show.missing_product')
    end
  end

  private

  def _set_product
    @product = Product.find_by(id: params[:id])
  end

  def _set_category
    @current_category = Category.find_by(slug: params[:category])
  end
end
