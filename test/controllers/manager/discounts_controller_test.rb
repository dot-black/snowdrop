require 'test_helper'

class DiscountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @discount = discounts(:one)
    @odd_discount = discounts(:two)
    @product = products(:new_bra)
    sign_in managers(:first) #Login as manager
  end

  test "should show all discounts" do
    get manager_discounts_path
    assert_response :success
    assert_equal "index", @controller.action_name
  end

  test "should show discount" do
    get manager_discount_path(@discount)
    assert_response :success
    assert_equal "show", @controller.action_name
  end

  test "should show new discount form" do
    get new_manager_discount_path
    assert_response :success
    assert_equal "new", @controller.action_name
  end

  test "should show edit discount form" do
    get edit_manager_discount_path(@discount)
    assert_response :success
    assert_equal "edit", @controller.action_name
  end

  test "should create discount" do
    assert_difference 'Discount.count' do
      post manager_discounts_path, params: {
        discount: {
          title: @discount.title,
          value: @discount.value,
          description: @discount.description,
        }
      }
    end
    assert_redirected_to manager_discounts_path
    assert_equal "Discount has been successfully created.", flash[:notice]
  end

  test "should not create discount if params are missing" do
    assert_no_difference 'Discount.count' do
      post manager_discounts_path, params: {
        discount: {
          description: @discount.description
        }
      }
    end
    assert_equal "Discount wasn't created, please check errors below!", flash[:notice]
  end

  test "should update discount" do
    put manager_discount_path(@discount), params: {
      discount: {
        title: "new title"
      }
    }
    assert_equal "Discount has been successfully updated.", flash[:notice]
  end

  test "should destroy discount" do
    assert_difference 'Discount.count', -1 do
      delete manager_discount_path(@odd_discount)
    end
    assert_redirected_to manager_discounts_path
    assert_equal "Discount has been successfully destroyed.", flash[:notice]
  end

  test "should not destroy discount" do
    assert_no_difference 'Product.count', -1 do
      delete manager_discount_path(@discount)
    end
    assert_redirected_to manager_discount_path(@discount)
    assert_equal "Discount can't be destroyed, because of 1 product involved.", flash[:notice]
  end

  test "should change appearance of discount" do
    get change_appearance_manager_discount_path(@discount)
    assert_redirected_to manager_discount_path(@discount)
    assert_equal "Discount is not active right now.", flash[:notice]

    get change_appearance_manager_discount_path(@discount)
    assert_redirected_to manager_discount_path(@discount)
    assert_equal "Discount activated.", flash[:notice]
  end

  test "should show edit products for discount" do
    get edit_products_manager_discount_path(@discount)
    assert_response :success
    assert_equal "edit_products", @controller.action_name
  end

  test "should add products to discount" do
    assert_no_difference '@discount.products.count' do
      put update_products_manager_discount_path(@discount), params:{
        product_ids: [@product.id]
      }
    end
  end
end
