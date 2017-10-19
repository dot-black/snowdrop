require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_visible = products :bra
    @product_hidden = products :bra_invisible
    @product_archived = products :bra_archive
    @product_of_invisible_category = products :panties_invisible_category
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should get to products of visible category #{locale}" do
      get category_products_path category: categories(:first_visible).slug, locale: locale
      assert_response :success
    end

    test "should not get to products of invisible category #{locale}" do
      get category_products_path category: categories(:second_invisible).slug, locale: locale
      assert_response :redirect
    end

    test "should show visible product #{locale}" do
      get product_url @product_visible, locale: locale
      assert_response :success
    end

    test "should not show hidden product #{locale}" do
      get product_url @product_hidden, locale: locale
      assert_response :redirect
    end

    test "should not show archived product #{locale}" do
      get product_url @product_archived, locale: locale
      assert_response :redirect
    end

    test "should not show product of hidden category #{locale}" do
      get product_url @product_of_invisible_category, locale: locale
      assert_response :redirect
    end
  end
end
