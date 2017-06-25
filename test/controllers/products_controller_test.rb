require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_visible = products(:iphone)
    @product_hiden = products(:macbook_invisible)
    @product_archived = products(:macbook_invisible)
    @product_of_invisible_category = products(:macbook_of_invisible_category)
  end

  test "should get to products of visible category" do
    get products_url(category: categories(:first_visible).id)
    assert_response :success
  end

  test "should not get to products of invisible category" do
    get products_url(category: categories(:second_invisible).id)
    assert_response :redirect
  end

  test "should show visible product" do
    get product_url(@product_visible)
    assert_response :success
  end

  test "should not show hiden product" do
    get product_url(@product_hiden)
    assert_response :redirect
  end

  test "should not show archived product" do
    get product_url(@product_archived)
    assert_response :redirect
  end

  test "should not show product of hiden category" do
    get product_url(@product_of_invisible_category)
    assert_response :redirect
  end


end
