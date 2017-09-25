require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @category = categories(:first_visible)
    @category.update image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
    @odd_category = categories(:third_to_delete)
    sign_in managers(:first) #Login as manager
  end

  test "should show all categories" do
    get manager_categories_path
    assert_response :success
    assert_equal "index", @controller.action_name
  end

  test "should show new category form" do
    get new_manager_category_path
    assert_response :success
    assert_equal "new", @controller.action_name
  end

  test "should show edit category form" do
    get edit_manager_category_path(@category)
    assert_response :success
    assert_equal "edit", @controller.action_name
  end

  test "should create category" do
    assert_difference 'Category.count' do
      post manager_categories_path, params: {
        category: {
          title: @category.title,
          image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
        }
      }

    end
    assert_redirected_to manager_categories_path
    assert_equal "Category was successfully created.", flash[:notice]
  end

  test "should not create product if params are missing" do
    assert_no_difference 'Category.count' do
      post manager_categories_path, params: {
        category: {
          title: @category.title
        }
      }
    end
  end

  test "should update category" do
    put manager_category_path(@category), params: {
      category: {
        image: fixture_file_upload(Rails.root.join('test','fixtures','files', 'image.png'))
      }
    }
    assert_equal "Category was successfully updated.", flash[:notice]
  end


  test "should destroy category" do
    assert_difference 'Category.count', -1 do
      delete manager_category_path(@odd_category)
    end
    assert_redirected_to manager_categories_path
    assert_equal "Category was successfully destroyed.", flash[:notice]
  end

  test "should not destroy category" do
    assert_no_difference 'Category.count', -1 do
      delete manager_category_path(@category)
    end
    assert_redirected_to manager_categories_path
    assert_equal "Category can't be destroyed, because of 2 orders involved.", flash[:notice]
  end

  test "should change appearance of category" do
    get change_appearance_manager_category_path(@category)
    assert_redirected_to manager_categories_path
    assert_equal "Category '#{@category.title}' is invisible now.", flash[:notice]

    get change_appearance_manager_category_path(@category)
    assert_redirected_to manager_categories_path
    assert_equal "Category '#{@category.title}' is visible now.", flash[:notice]
  end

end
