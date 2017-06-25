require 'test_helper'

class ClienStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    iphone = products(:iphone)

    get "/"
    assert_response :success
    assert_template "index"

    post '/line_items', params: { line_item: { product_id: iphone.id }}, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal iphone, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    post "/orders", params: {
      order: {
        name:     "Daniel Defoe",
        email:    "daniel@example.com",
        telephone: "+380631001010"
      }
    }
    follow_redirect!
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Daniel Defoe",       order.name
    assert_equal "daniel@example.com", order.email
    assert_equal "+380631001010",      order.telephone

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal iphone, line_item.product

    # mail = ActionMailer::Base.deliveries.last
    # assert_equal ["dave@example.com"], mail.to
    # assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    # assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "check if the same product with same size gets to the same line item " do
    LineItem.delete_all
    Order.delete_all
    iphone = products(:iphone)

    4.times do
      post '/line_items', params: { line_item: { product_id: iphone.id, size: Product.sizes.values.first }}, xhr: true
      assert_response :success
    end

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal 4, cart.line_items.last.quantity
  end

  test "check if the same product with different sizes gets to the different line items " do
    LineItem.delete_all
    Order.delete_all
    iphone = products(:iphone)

    post '/line_items', params: { line_item: { product_id: iphone.id, size: Product.sizes.values.first }}, xhr: true
    assert_response :success

    post '/line_items', params: { line_item: { product_id: iphone.id, size: Product.sizes.values.second }}, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 2, cart.line_items.size
    assert_equal 1, cart.line_items.first.quantity
    assert_equal 1, cart.line_items.second.quantity
  end

end
