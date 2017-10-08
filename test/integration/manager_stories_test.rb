require 'test_helper'

class ManagerStoriesTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "login as manager #{locale}" do
      get manager_root_path locale: locale
      assert_redirected_to new_manager_session_path locale: locale
      post manager_session_path(locale: locale), params: {
        manager:{
          email: "test@manager.com",
          password: "qweqweqwe"
        }
      }
      assert_redirected_to manager_dashboard_path locale: locale
    end

    test "check dashboard #{locale}" do
      sign_in managers :first  #Login as manager
      get manager_dashboard_path(locale: locale)
      assert_template :index
    end

    test "check categories #{locale}" do
      sign_in managers :first  #Login as manager

      get manager_categories_path locale: locale
      assert_response :success
      assert_template :index

      get new_manager_category_path locale: locale
      assert_response :success
      assert_template :new

      post manager_categories_path(locale: locale), params: {
        category:{
          title: "New category",
          slug: "new",
          image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
        }
      }
      assert_redirected_to manager_categories_path
      new_category = Category.find_by title: "New category"
      assert new_category.present?
      assert_not new_category.visible

      get edit_manager_category_path(new_category, locale: locale)
      assert_response :success
      assert_template :edit

      put manager_category_path(new_category, locale: locale), params: {
        category:{
          title: "Updated category"
        }
      }

      get change_appearance_manager_category_path(new_category, locale: locale)
      new_category = Category.find_by title: "Updated category"
      assert new_category.present?
      assert new_category.visible

      delete manager_category_path(new_category, locale: locale)
      assert_raises ActiveRecord::RecordNotFound do
        Category.find new_category.id
      end
    end

    test "check products #{locale}" do
      sign_in managers :first #Login as manager

      get manager_products_path locale: locale
      assert_response :success
      assert_template :index

      get new_manager_product_path locale: locale
      assert_response :success
      assert_template :new

      post manager_products_path(locale: locale), params: {
        product:{
          title: "New product",
          price: 435,
          category_id: Category.last.id,
          priority: "hi",
          description: "Sample description",
          sizes:{ standard:["XS"], bra:["70C"] }
        }
      }
      assert_redirected_to manager_products_path locale: locale
      new_product = Product.find_by title: "New product"
      assert new_product.present?
      assert_not new_product.visible

      get manager_product_path new_product, locale: locale
      assert_response :success
      assert_template :show

      get edit_manager_product_path new_product, locale: locale
      assert_response :success
      assert_template :edit

      put manager_product_path(new_product, locale: locale), params: {
        product: {
          title: "Updated product"
        }
      }
      get change_appearance_manager_product_path new_product, locale: locale
      new_product = Product.find_by title: "Updated product"
      assert new_product.present?
      assert new_product.visible

      get archive_manager_product_path new_product, locale: locale
      new_product = Product.find new_product.id
      assert new_product.present?
      assert_not new_product.visible

      get archival_manager_products_path locale: locale
      assert_template :archival

      delete manager_product_path new_product, locale: locale
      assert_raises(ActiveRecord::RecordNotFound) do
        Category.find(new_product.id)
      end
    end

    test "check orders #{locale}" do
      sign_in managers :first #Login as manager

      get manager_orders_path status: :all, locale: locale
      assert_response :success
      assert_template :index

      order = Order.last
      get manager_order_path order, locale: locale
      assert_response :success
      assert_template :show

      put manager_order_path(order, locale: locale), params: {
        order: {
          status: "accepted"
        }
      }
      assert_redirected_to manager_orders_path(status: :accepted, locale: locale)
    end

    test "check users #{locale}" do
      sign_in managers :first #Login as manager

      get manager_users_path locale: locale
      assert_response :success
      assert_template :index

      user = User.last
      get manager_user_path user, locale: locale
      assert_response :success
      assert_template :show
    end

    test "check discounts #{locale}" do
      sign_in managers :first #Login as manager

      get manager_discounts_path locale: locale
      assert_response :success
      assert_template :index

      get new_manager_discount_path locale: locale
      assert_response :success
      assert_template :new

      post manager_discounts_path(locale: locale), params:{
        discount:{
          title: "New discount",
          value: 10
        }
      }
      assert_redirected_to manager_discounts_path locale: locale

      discount = Discount.last
      get manager_discount_path discount, locale: locale
      assert_response :success
      assert_template :show

      get edit_manager_discount_path discount, locale: locale
      assert_response :success
      assert_template :edit

      put manager_discount_path(discount, locale: locale), params:{
        discount:{
          title: "Updated title",
          value: 20
        }
      }
      assert_redirected_to manager_discount_path discount, locale: locale

      get change_appearance_manager_discount_path discount, locale: locale
      assert_redirected_to manager_discount_path discount, locale: locale

      get edit_products_manager_discount_path discount, locale: locale
      assert_response :success
      assert_template :edit_products

      put update_products_manager_discount_path(discount, locale: locale), params:{
        product_ids: Product.all.ids
      }
      assert_redirected_to edit_products_manager_discount_path discount, locale: locale
    end
  end
end
