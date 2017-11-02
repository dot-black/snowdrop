require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @order = orders :one

    sign_in managers :first #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should not show orders when status parameter is invalid #{locale}" do
      get manager_orders_path(status: "invalid", locale: locale)
      assert_redirected_to manager_orders_path(locale: locale)
      assert_equal (I18n.translate 'manager.orders.flash.index.prohibited'), flash[:notice]
    end

    test "should show all orders #{locale}" do
      get manager_orders_path locale: locale
      assert_response :success
    end

    test "should filter orders by status #{locale}" do
      Order.statuses.keys.each do |status|
        get manager_orders_path(status: status, locale: locale), xhr: true
        assert_response :success
        assert_equal "text/javascript", @response.content_type
      end
    end

    test "should filter by search query #{locale}" do
      get manager_orders_path(search_query: "something", locale: locale), xhr: true
      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "should show order #{locale}" do
      get manager_order_path(@order, locale: locale)
      assert_response :success
    end

    test "should update status of order #{locale}" do
      Order.statuses.keys.each do |status|
        put manager_order_path(@order,locale: locale), params: { order: { status: status }}
        manager_orders_path(status: status,locale: locale)
        assert_equal (I18n.translate 'manager.orders.flash.update.success'), flash[:notice]
      end
    end
  end
end
