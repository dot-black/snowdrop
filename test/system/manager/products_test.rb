require "application_system_test_case"

class Manager::ProductsTest < ApplicationSystemTestCase
  setup do
    @product_visible = products(:bra)
    @product_invisible = products(:bra_invisible)
    #Login as manager
    visit manager_root_path
    fill_in 'Email', with: 'test@manager.com'
    fill_in 'Password',with: "qweqweqwe"
    click_on 'Log in'
    visit manager_products_path
  end

  test 'check index' do
    #Check basic elements
    assert_selector "h2", text: 'Products'
    has_content?  @product_visible.title
    has_content? @product_invisible.title
    assert_selector "button", text: "All products"
    assert_selector "a", text: "New"
    #Check filter
    find("#manager-products-filter").click
    click_on "Visible"
    assert_selector "button", text: "Visible"
    has_content? @product_visible.title
    has_no_content? @product_invisible.title
    find("#manager-products-filter").click
    click_on "Hiden"
    assert_selector "button", text: "Hiden"
    has_no_content? @product_visible.title
    has_content? @product_invisible.title
  end

  test 'check new' do
    #Check validation
    click_on "New"
    click_on "Create Product"
    has_content? '6 errors prohibited this category from being saved:'
    fill_in 'Title', with: 'some title'
    fill_in 'Price', with: "12,99"
    click_on "Select category"
    sleep
    find('span', text: "Brief").first(:xpath, '..//..').click

    click_on "Pick bra sizes"
    find('span', text: "S").first(:xpath, '..//..').click


  end



end
