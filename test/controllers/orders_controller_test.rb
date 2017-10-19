require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should not get new unless cart is empty #{locale}" do
      get new_order_url locale: locale
      assert_response :redirect
    end

    test "should create order #{locale}" do
      post users_url(locale: locale), params: {
        user: {
          email: 'test@email.com'
        }
      }
      post user_informations_url(locale: locale), params:{
        user_information:{
          name: 'some name',
          telephone: '456789876545'
        }
      }
      assert_difference('Order.count') do
        post orders_url(locale: locale), params: {
          order: {
            comment: @order.comment
          }
        }
      end
    end
  end
end
