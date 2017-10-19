require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @category = categories(:first_visible)
    @category.update image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
    @odd_category = categories(:third_to_delete)
    sign_in managers(:first) #Login as manager
  end
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show all categories #{locale}" do
      get manager_categories_path locale: locale
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show new category form #{locale}" do
      get new_manager_category_path locale: locale
      assert_response :success
      assert_equal "new", @controller.action_name
    end

    test "should show edit category form #{locale}" do
      get edit_manager_category_path @category, locale: locale
      assert_response :success
      assert_equal "edit", @controller.action_name
    end

    test "should create category #{locale}" do
      assert_difference 'Category.count' do
        post manager_categories_path(locale: locale), params: {
          category: {
            title: @category.title,
            slug: "#{@category.title.parameterize}#{locale}",
            image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
          }
        }
      end
      assert_redirected_to manager_categories_path locale: locale
      assert_equal (I18n.translate 'manager.categories.flash.create.success'), flash[:notice]
    end

    test "should not create category if params are missing #{locale}" do
      assert_no_difference 'Category.count' do
        post manager_categories_path(locale: locale), params: {
          category: {
            title: @category.title
          }
        }
      end
      assert_equal (I18n.translate 'manager.categories.flash.create.failure'), flash[:notice]
    end

    test "should update category #{locale}" do
      put manager_category_path(@category, locale: locale), params: {
        category: {
          image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
        }
      }
      assert_equal (I18n.translate 'manager.categories.flash.update.success'), flash[:notice]
    end

    test "should not update category if validation is failed #{locale}" do
      put manager_category_path(@category, locale: locale), params: {
        category: {
          title: ""
        }
      }
      assert_equal (I18n.translate 'manager.categories.flash.update.failure'), flash[:notice]
    end


      test "should destroy category #{locale}" do
        assert_difference 'Category.count', -1 do
          delete manager_category_path @odd_category, locale: locale
        end
        assert_redirected_to manager_categories_path locale: locale
        assert_equal (I18n.translate 'manager.categories.flash.destroy.success.'), flash[:notice]
    end

    test "should not destroy category if something is invlved #{locale}" do
      assert_no_difference 'Category.count', -1 do
        delete manager_category_path @category,locale: locale
      end
      assert_redirected_to manager_categories_path locale: locale
      assert_equal (I18n.translate 'manager.categories.flash.destroy.involvement'), flash[:notice]
    end

    test "should change appearance of category #{locale}" do
      get change_appearance_manager_category_path @category, locale: locale
      assert_redirected_to manager_categories_path locale: locale
      assert_equal (I18n.translate 'manager.categories.flash.change_appearance.invisible'), flash[:notice]

      get change_appearance_manager_category_path @category, locale: locale
      assert_redirected_to manager_categories_path locale: locale
      assert_equal (I18n.translate 'manager.categories.flash.change_appearance.visible'), flash[:notice]
    end
  end
end
