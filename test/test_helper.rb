require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'carrierwave_test_config'

Capybara.javascript_driver = :chrome

class ActiveSupport::TestCase
  fixtures :all

protected
  def _set_user user, locale
    post users_url(locale: locale), params: { user: user.as_json }
  end

  def _set_user_information user_information, locale
    post user_informations_url(locale: locale), params: { user_information: user_information.as_json }
  end

  def _set_line_item line_item, locale
    post line_items_url(locale: locale), params: { line_item: line_item.as_json }
  end

  def _set_order order, locale
    post orders_url(locale: locale), params: { order: order.as_json }
  end
end
