require 'test_helper'
require 'sidekiq/testing/inline'

class ClienStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "buying a product #{locale}" do
      LineItem.delete_all
      Order.delete_all
      bra = products :bra

      get store_path locale: locale
      assert_response :success
      assert_template :index

      post line_items_path(locale: locale), params: { line_item: { product_id: bra.id, size: { bra: bra.sizes["bra"].first} }}, xhr: true
      assert_response :success

      cart = Cart.find(session[:cart_id])
      assert_equal 1, cart.line_items.size
      assert_equal bra, cart.line_items.first.product

      get new_order_path locale: locale
      assert_response :redirect
      post users_path(locale: locale), params: {
        user: {
          email: 'daniel@example.com',
        }
      }
      assert_response :redirect
      post user_informations_path(locale: locale), params: {
        user_information: {
          name: 'Daniel Defoe',
          telephone: '+380631001010'
        }
      }
      assert_response :redirect
      post orders_path(locale: locale), params: {
        order: {
          comment: "A nice comment"
        }
      }
      assert_response :success
      assert_template "successful_order"
      orders = Order.all
      assert_equal 1, orders.size
      order = orders[0]

      assert_equal "Daniel Defoe",       order.user_information.name
      assert_equal "daniel@example.com", order.user.email
      assert_equal "+380631001010",      order.user_information.telephone

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal bra, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["daniel@example.com"], mail.to
      assert_equal 'aridar@example.com', mail[:from].value
      assert_equal "#{I18n.translate 'order_mailer.client_information.subject'}", mail.subject
    end

    test "check if the same product with same size gets to the same line item #{locale}" do
      LineItem.delete_all
      Order.delete_all
      bra = products :bra

      4.times do
        post line_items_path(locale: locale), params: { line_item: { product_id: bra.id, size: { standard: Product.sizes[:standard].first } }}, xhr: true
        assert_response :success
      end

      cart = Cart.find session[:cart_id]
      assert_equal 1, cart.line_items.size
      assert_equal 4, cart.line_items.last.quantity
    end

    test "check if the same product with different sizes gets to the different line items #{locale}" do
      LineItem.delete_all
      Order.delete_all
      bra = products(:bra)

      post line_items_path(locale: locale), params: { line_item: { product_id: bra.id, size: { bra: Product.sizes[:bra].first } }}, xhr: true
      assert_response :success

      post line_items_path(locale: locale), params: { line_item: { product_id: bra.id, size: { bra: Product.sizes[:bra].second } }}, xhr: true
      assert_response :success

      cart = Cart.find session[:cart_id]
      assert_equal 2, cart.line_items.size
      assert_equal 1, cart.line_items.first.quantity
      assert_equal 1, cart.line_items.second.quantity
    end
  end
end
