require 'test_helper'

class ClienStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    bra = products(:bra)

    get "/"
    assert_response :success
    assert_template "index"

    post '/line_items', params: { line_item: { product_id: bra.id, size: { bra: bra.sizes["bra"].first} }}, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal bra, cart.line_items.first.product

    get "/orders/new"
    assert_response :redirect
    post users_path params: {
      user: {
        name: 'Daniel Defoe',
        email: 'daniel@example.com',
        telephone: '+380631001010'
      }
    }
    assert_response :redirect
    post "/orders", params: {
      order: {
        comment: "A nice comment"
      }
    }
    assert_response :success
    assert_template "successful_order"
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Daniel Defoe",       order.user.name
    assert_equal "daniel@example.com", order.user.email
    assert_equal "+380631001010",      order.user.telephone

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal bra, line_item.product

    # mail = ActionMailer::Base.deliveries.last
    # assert_equal ["dave@example.com"], mail.to
    # assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    # assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "check if the same product with same size gets to the same line item " do
    LineItem.delete_all
    Order.delete_all
    bra = products(:bra)

    4.times do
      post '/line_items', params: { line_item: { product_id: bra.id, size: { standard: Product.sizes[:standard].first } }}, xhr: true
      assert_response :success
    end

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal 4, cart.line_items.last.quantity
  end

  test "check if the same product with different sizes gets to the different line items " do
    LineItem.delete_all
    Order.delete_all
    bra = products(:bra)

    post '/line_items', params: { line_item: { product_id: bra.id, size: { bra: Product.sizes[:bra].first } }}, xhr: true
    assert_response :success

    post '/line_items', params: { line_item: { product_id: bra.id, size: { bra: Product.sizes[:bra].second } }}, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 2, cart.line_items.size
    assert_equal 1, cart.line_items.first.quantity
    assert_equal 1, cart.line_items.second.quantity
  end

end
