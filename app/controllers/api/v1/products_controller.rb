module Api
  module V1
    class ProductsController < ApplicationController
      def index
        unless params[:category].present? and _set_category and @current_category.visible
          @success = false
          @outcome = { warning: "Can't find products of the category" }
        else
          @success = true
          @outcome = {
            category: @current_category,
            products: Product.shown.by_category(@current_category.id).page(params[:page]),
            count: Product.shown.by_category(@current_category.id).count
          }
        end
        _render_response
      end


      def show
        unless params[:id].present? and _set_product and _set_product_category.visible
          @success = false
          @outcome = { warning: "Can't find product" }
        else
          @success = true
          @outcome = {
            categorySlug: @category.slug,
            product: @product,
          }
        end
        _render_response
      end

    private
      def _render_response
        render json: @outcome, status: @success ? :ok : :unprocessable_entity
      end

      def _set_category
        @current_category = FetchCategory.run!(category_parameter: params[:category])
      end

      def _set_product
        @product = Product.find_by_id params[:id]
      end

      def _set_product_category
        @category = @product.category
      end

    end
  end
end
