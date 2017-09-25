require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @order = orders(:one)
    sign_in managers(:first) #Login as manager
  end

  test "should not show orders when status parameter not present or invalid" do
    get manager_orders_path
    assert_redirected_to manager_dashboard_path
    assert_equal "Status parameter must be present.", flash[:notice]
    get manager_orders_path(status: "invalid")
    assert_redirected_to manager_dashboard_path
    assert_equal "Status parameter 'invalid' is prohibited.", flash[:notice]
  end

  test "should show all orders" do
    get manager_orders_path(status: "all")
    assert_response :success
  end

  test "should filter orders by status" do
    Order.statuses.keys.each do |status|
      get manager_orders_path(status: status), xhr: true
      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end
  end

  test "should filter by search query" do
    get manager_orders_path(status: "all", search_query: "something"), xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.content_type
  end

  test "should show order" do
    get manager_order_path @order
    assert_response :success
  end

  test "should update status of order" do
    Order.statuses.keys.each do |status|
      put manager_order_path @order, params: {
        order: {
          status: status
        }
      }
      manager_orders_path(status: status)
      assert_equal "Status of order ##{@order.id} has been changed.", flash[:notice]
    end
  end
end
