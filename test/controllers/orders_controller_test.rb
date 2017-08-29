require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should not get new unless cart is empty" do
    get new_order_url
    assert_response :redirect
  end

  test "should create order" do
    post users_url, params: {
      user: {
        name: 'some name',
        email: 'test@email.com',
        telephone: '456789876545'
      }
    }
    assert_difference('Order.count') do
      post orders_url, params: {
        order: {
          comment: @order.comment
        }
      }
    end
  end

end
