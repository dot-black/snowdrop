module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        @success = true
        @outcome = Category.visible
        _render_response
      end

    private
      def _render_response
        render json: @outcome, status: @success ? :ok : :unprocessable_entity
      end

    end
  end
end
