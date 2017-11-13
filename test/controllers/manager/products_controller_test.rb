require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @product = products :bra
    @odd_product = products :odd_product

    sign_in managers :first #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show all products #{locale}" do
      get manager_products_path locale: locale
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show products by category #{locale}" do
      get manager_products_path(manager_category: @product.category, locale: locale)
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show visible products #{locale}" do
      get manager_products_path(visible: true, locale: locale)
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show hidden products #{locale}" do
      get manager_products_path(hidden: true, locale: locale)
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show archival products #{locale}" do
      get archival_manager_products_path locale: locale
      assert_response :success
      assert_equal "archival", @controller.action_name
    end

    test "should show product #{locale}" do
      get manager_product_path(@product, locale: locale)
      assert_response :success
      assert_equal "show", @controller.action_name
    end

    test "should show new product form #{locale}" do
      get new_manager_product_path locale: locale
      assert_response :success
      assert_equal "new", @controller.action_name
    end

    test "should show edit product form #{locale}" do
      get edit_manager_product_path(@product, locale: locale)
      assert_response :success
      assert_equal "edit", @controller.action_name
    end

    test "should create product #{locale}" do
      assert_difference 'Product.count' do
        post manager_products_path(locale: locale), params: { product: @product.as_json }
      end
      assert_redirected_to manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.create.success'), flash[:notice]
    end

    test "should not create product if params are missing #{locale}" do
      assert_no_difference 'Product.count' do
        post manager_products_path(locale: locale), params: { product: @product.as_json(only: [:title]) }
      end
      assert_equal (I18n.translate 'manager.products.flash.create.failure'), flash[:notice]
    end

    test "should update product #{locale}" do
      put manager_product_path(@product,locale: locale), params: { product: { title: "new title" } }
      assert_equal (I18n.translate 'manager.products.flash.update.success'), flash[:notice]
    end

    test "should not update product if validation failed #{locale}" do
      put manager_product_path(@product,locale: locale), params: { product: { title: "" } }
      assert_equal (I18n.translate 'manager.products.flash.update.failure'), flash[:notice]
    end

    test "should archive and restore product #{locale}" do
      get archive_manager_product_path(@product,locale: locale)
      assert_redirected_to manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.archive.archived'), flash[:notice]
      get archive_manager_product_path(@product,locale: locale)
      assert_redirected_to archival_manager_products_path
      assert_equal (I18n.translate 'manager.products.flash.archive.restored'), flash[:notice]
    end

    test "should destroy product #{locale}" do
      assert_difference 'Product.count', -1 do
        delete manager_product_path(@odd_product,locale: locale)
      end
      assert_redirected_to archival_manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.destroy.success'), flash[:notice]
    end

    test "should not destroy product #{locale}" do
      assert_no_difference 'Product.count', -1 do
        delete manager_product_path(@product, locale: locale)
      end
      assert_redirected_to archival_manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.destroy.involvement'), flash[:notice]
    end

    test "should change appearance of product #{locale}" do
      get change_appearance_manager_product_path(@product, locale: locale)
      assert_redirected_to manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.appearance.invisible'), flash[:notice]

      get change_appearance_manager_product_path(@product, locale: locale)
      assert_redirected_to manager_products_path locale: locale
      assert_equal (I18n.translate 'manager.products.flash.appearance.visible'), flash[:notice]
    end
  end
end
