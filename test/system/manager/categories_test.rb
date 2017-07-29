require "application_system_test_case"

class Manager::CategoriesTest < ApplicationSystemTestCase
  setup do
    @category_first = categories(:first_visible)
    @category_second = categories(:second_invisible)
    @category_third = categories(:third_to_delete)
    #Login as manager
    visit manager_root_path
    fill_in 'Email', with: 'test@manager.com'
    fill_in 'Password',with: "qweqweqwe"
    click_on 'Log in'
    visit manager_categories_path
  end
  test "check index" do
    assert_selector "h2", text: 'Categories'
    assert_selector "span", text: @category_first.title
    assert_selector "span", text: @category_second.title
    assert_selector "a", text: "New"
  end
  test "create new category" do
    click_on 'New'
    #Check validation
    click_on 'Create Category'
    assert_selector "h2", text: '2 errors prohibited this category from being saved:'
    #Fill in data and create "New category"
    fill_in 'Title', with: "New category"
    attach_file("category_image", Rails.root.join("test/fixtures/files/image.png"))
    check "Complex"
    click_on 'Create Category'
    #Check creation of category
    assert_selector ".toast", text: 'Category was successfully created'
    assert_selector "span", text: "New category"
  end
  test "update category" do
    click_on @category_first.title
    check "Complex"
    fill_in 'Title', with: 'First category updated'
    attach_file("category_image", Rails.root.join("test/fixtures/files/image.png"))
    click_on 'Update Category'
    #Check updation of category
    assert_selector ".toast", text: "Category was successfully updated"
  end
  test "delete category" do
    #Check if it's unable to delete category if line items exist
    find("span",text: @category_first.title).first(:xpath, '..//..').click_link('Delete')
    assert_selector ".toast", text: "Category can't be destroyed, there are 2 products involved."
    #Check if products to delete if category is deleted
    assert_difference 'Product.count', -@category_third.products.count do
      find("span",text: @category_third.title).first(:xpath, '..//..').click_link('Delete')
      assert_selector ".toast", text: "Category was successfully destroyed."
      has_no_content?(@category_third.title)
    end
  end
  test "change apperance of category" do
    #Change apperance for visibel and invisible categories
    find("span",text: @category_first.title).first(:xpath, '..//..').click_link('Hide')
    accept_confirm
    find("span",text: @category_second.title).first(:xpath, '..//..').click_link('Release')
    accept_confirm
    #Check categories on client's side
    visit store_path
    has_no_content? @category_first.title
    has_content? @category_second.title
  end
end
