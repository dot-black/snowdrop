require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @product = products(:bra)
    @odd_product = products(:odd_product)
    sign_in managers(:first) #Login as manager
  end

  test "should show all products" do
    get manager_products_path
    assert_response :success
    assert_equal "index", @controller.action_name
  end

  test "should show products by category" do
    get manager_products_path(manager_category: @product.category), xhr: true
    assert_response :success
    assert_equal "index", @controller.action_name
    assert_equal "text/javascript", @response.content_type
  end

  test "should show visible products" do
    get manager_products_path(visible: true), xhr: true
    assert_response :success
    assert_equal "index", @controller.action_name
    assert_equal "text/javascript", @response.content_type
  end

  test "should show hidden products" do
    get manager_products_path(hidden: true), xhr: true
    assert_response :success
    assert_equal "index", @controller.action_name
    assert_equal "text/javascript", @response.content_type
  end

  test "should show archival products" do
    get archival_manager_products_path
    assert_response :success
    assert_equal "archival", @controller.action_name
  end

  test "should show product" do
    get manager_product_path(@product)
    assert_response :success
    assert_equal "show", @controller.action_name
  end

  test "should show new product form" do
    get new_manager_product_path
    assert_response :success
    assert_equal "new", @controller.action_name
  end

  test "should show edit product form" do
    get edit_manager_product_path(@product)
    assert_response :success
    assert_equal "edit", @controller.action_name
  end

  test "should create product" do
    assert_difference 'Product.count' do
      post manager_products_path, params: {
        product: {
          title: @product.title,
          description: @product.description,
          category_id: @product.category_id,
          price: @product.price,
          sizes: @product.sizes
        }
      }
    end
    assert_redirected_to manager_products_path
    assert_equal "Product has been successfully created.", flash[:notice]
  end

  test "should not create product if params are missing" do
    assert_no_difference 'Product.count' do
      post manager_products_path, params: {
        product: {
          category_id: @product.category_id
        }
      }
    end
    assert_equal "Product wasn't created, please check errors below!", flash[:notice]
  end

  test "should update product" do
    put manager_product_path(@product), params: {
      product: {
        title: "new title"
      }
    }
    assert_equal "Product has been successfully updated.", flash[:notice]
  end

  test "should archive and restore product" do
    get archive_manager_product_path(@product)
    assert_redirected_to manager_products_path
    assert_equal "Product #{@product.title} has been archived.", flash[:notice]
    get archive_manager_product_path(@product)
    assert_redirected_to archival_manager_products_path
    assert_equal "Product #{@product.title} has been restored.", flash[:notice]
  end

  test "should destroy product" do
    assert_difference 'Product.count', -1 do
      delete manager_product_path(@odd_product)
    end
    assert_redirected_to archival_manager_products_path
    assert_equal "Product has been successfully destroyed.", flash[:notice]
  end

  test "should not destroy product" do
    assert_no_difference 'Product.count', -1 do
      delete manager_product_path(@product)
    end
    assert_redirected_to archival_manager_products_path
    assert_equal "Product can't be destroyed, because of 1 order involved.", flash[:notice]
  end

  test "should change appearance of product" do
    get change_appearance_manager_product_path(@product)
    assert_redirected_to manager_products_path
    assert_equal "Product '#{@product.title }' has become invisible.", flash[:notice]

    get change_appearance_manager_product_path(@product)
    assert_redirected_to manager_products_path
    assert_equal "Product '#{@product.title }' has become visible.", flash[:notice]
  end

end
