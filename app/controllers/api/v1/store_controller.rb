module Api
  module V1
    class StoreController < ApplicationController
      def index
        @outcome = {
          locale:  I18n.locale,
          locales: I18n.available_locales,
          appName:   t('application_name'),
          shortName: t('application_name_short'),
          actionButtonText: t('store.index.shop_now'),
          footerButtonText: t('contacts'),
          drawerPoints: {
            category: t('category'),
            language: t('language')
          }
        }
        @success = true
        _render_response
      end

    private
      def _render_response
        render json: @outcome, status: @success ? :ok : :unprocessable_entity
      end
    end
  end
end
