require 'test_helper'

class DiscountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @discount = discounts :one
    @odd_discount = discounts :two
    @product = products :new_bra

    sign_in managers :first #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show all discounts #{locale}" do
      get manager_discounts_path locale: locale
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show discount #{locale}" do
      get manager_discount_path(@discount,locale: locale)
      assert_response :success
      assert_equal "show", @controller.action_name
    end

    test "should show new discount form #{locale}" do
      get new_manager_discount_path locale: locale
      assert_response :success
      assert_equal "new", @controller.action_name
    end

    test "should show edit discount form #{locale}" do
      get edit_manager_discount_path(@discount,locale: locale)
      assert_response :success
      assert_equal "edit", @controller.action_name
    end

    test "should create discount #{locale}" do
      assert_difference 'Discount.count' do
        post manager_discounts_path(locale: locale), params: { discount: @discount.as_json }
      end
      assert_redirected_to manager_discounts_path(locale: locale)
      assert_equal (I18n.translate 'manager.discounts.flash.create.success'), flash[:notice]
    end

    test "should not create discount if params are missing #{locale}" do
      assert_no_difference 'Discount.count' do
        post manager_discounts_path(locale: locale), params: { discount: @discount.as_json(only: [:description]) }
      end
      assert_equal (I18n.translate 'manager.discounts.flash.create.failure'), flash[:notice]
    end

    test "should update discount #{locale}" do
      put manager_discount_path(@discount,locale: locale), params: { discount: { title: "New"} }
      assert_equal (I18n.translate 'manager.discounts.flash.update.success'), flash[:notice]
    end

    test "should not update discount if validation is failed #{locale}" do
      put manager_discount_path(@discount,locale: locale), params: { discount: { title: "" } }
      assert_equal (I18n.translate 'manager.discounts.flash.update.failure'), flash[:notice]
    end

    test "should destroy discount #{locale}" do
      assert_difference 'Discount.count', -1 do
        delete manager_discount_path(@odd_discount,locale: locale)
      end
      assert_redirected_to manager_discounts_path
      assert_equal (I18n.translate 'manager.discounts.flash.destroy.success'), flash[:notice]
    end

    test "should not destroy discount #{locale}" do
      assert_no_difference 'Product.count', -1 do
        delete manager_discount_path(@discount,locale: locale)
      end
      assert_redirected_to manager_discount_path(@discount,locale: locale)
      assert_equal (I18n.translate 'manager.discounts.flash.destroy.involvement'), flash[:notice]
    end

    test "should change appearance of discount #{locale}" do
      get change_appearance_manager_discount_path(@discount,locale: locale)
      assert_redirected_to manager_discount_path(@discount,locale: locale)
      assert_equal (I18n.translate 'manager.discounts.flash.change_appearance.invisible'), flash[:notice]

      get change_appearance_manager_discount_path(@discount,locale: locale)
      assert_redirected_to manager_discount_path(@discount,locale: locale)
      assert_equal (I18n.translate 'manager.discounts.flash.change_appearance.visible'), flash[:notice]
    end

    test "should show edit products for discount #{locale}" do
      get edit_products_manager_discount_path(@discount,locale: locale)
      assert_response :success
      assert_equal "edit_products", @controller.action_name
    end

    test "should add products to discount #{locale}" do
      assert_no_difference '@discount.products.count' do
        put update_products_manager_discount_path(@discount,locale: locale), params:{
          product_ids: [@product.id]
        }
      end
    end
  end
end
