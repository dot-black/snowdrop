require 'test_helper'

class ManagerStoriesTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers

  test "login as manager" do
    get "/manager"
    assert_redirected_to new_manager_session_path
    post manager_session_path, params: {
      manager:{
        email: "test@manager.com",
        password: "qweqweqwe"
      }
    }
    assert_redirected_to manager_dashboard_path
  end

  test "check dashboard" do
    sign_in managers(:first) #Login as manager
    get "/manager/dashboard"
    assert_template :index
  end

  test "check categories" do
    sign_in managers(:first) #Login as manager

    get "/manager/categories"
    assert_response :success
    assert_template "index"

    get "/manager/categories/new"
    assert_response :success
    assert_template "new"

    post "/manager/categories", params: {
      category: {
        title: "New category",
        image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
      }
    }
    assert_redirected_to manager_categories_path
    new_category = Category.find_by_title("New category")
    assert new_category.present?
    assert_not new_category.visible

    get "/manager/categories/#{new_category.id}/edit"
    assert_response :success
    assert_template "edit"

    put "/manager/categories/#{new_category.id}", params: {
      category: {
        title: "Updated category"
      }
    }
    get "/manager/categories/#{new_category.id}/change_appearance"
    new_category = Category.find_by_title("Updated category")
    assert new_category.present?
    assert new_category.visible

    delete "/manager/categories/#{new_category.id}"
    assert_raises(ActiveRecord::RecordNotFound) do
      Category.find(new_category.id)
    end
  end

  test "check products" do
    sign_in managers(:first) #Login as manager

    get "/manager/products"
    assert_response :success
    assert_template "index"

    get "/manager/products/new"
    assert_response :success
    assert_template "new"

    post "/manager/products", params: {
      product: {
        title: "New product",
        price: 435,
        category_id: Category.last.id,
        priority: "hi",
        description:"Sample description",
        sizes: {standard:["XS"], bra:["70C"]}
      }
    }
    assert_redirected_to manager_products_path
    new_product = Product.find_by_title("New product")
    assert new_product.present?
    assert_not new_product.visible

    get "/manager/products/#{new_product.id}"
    assert_response :success
    assert_template "show"

    get "/manager/products/#{new_product.id}/edit"
    assert_response :success
    assert_template "edit"

    put "/manager/products/#{new_product.id}", params: {
      product: {
        title: "Updated product"
      }
    }
    get "/manager/products/#{new_product.id}/change_appearance"
    new_product = Product.find_by_title("Updated product")
    assert new_product.present?
    assert new_product.visible

    get "/manager/products/#{new_product.id}/archive"
    new_product = Product.find(new_product.id)
    assert new_product.present?
    assert_not new_product.visible

    get "/manager/products/archival"
    assert_template :archival

    delete "/manager/products/#{new_product.id}"
    assert_raises(ActiveRecord::RecordNotFound) do
      Category.find(new_product.id)
    end
  end

  test "check orders" do
    sign_in managers(:first) #Login as manager

    get "/manager/orders?status=all"
    assert_response :success
    assert_template "index"

    order = Order.last
    get "/manager/orders/#{order.id}"
    assert_response :success
    assert_template "show"

    put "/manager/orders/#{order.id}", params: {
      order: {
        status: "accepted"
      }
    }
    assert_redirected_to manager_orders_path(status: "accepted")
  end
end
