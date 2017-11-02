require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders :one
    @user = users :first
    @user_information = user_informations :one
    @line_item = line_items :one
  end

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "shouldn't get to new order unless user exists #{locale}" do
      get new_order_url locale: locale
      assert_response :redirect
    end
    test "shouldn't get to new order unless user information exists #{locale}" do
      _set_user @user, locale
      get new_order_url locale: locale
      assert_response :redirect
    end
    test "shouldn't get to new order unless line items exist #{locale}" do
      _set_user @user, locale
      _set_user_information @user_information, locale
      get new_order_url locale: locale
      assert_response :redirect
    end
    test "should get new unless cart is empty #{locale}" do
      _set_user @user, locale
      _set_user_information @user_information, locale
      _set_line_item @line_item, locale
      get new_order_url locale: locale
      assert_response :success
    end

    test "should create order #{locale}" do
      _set_user @user, locale
      _set_user_information @user_information, locale
      assert_difference('Order.count') do
        _set_order @order, locale
      end
    end
  end
end
