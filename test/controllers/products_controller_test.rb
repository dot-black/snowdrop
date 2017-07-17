require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_visible = products(:bra)
    @product_hiden = products(:bra_invisible)
    @product_archived = products(:bra_archive)
    @product_of_invisible_category = products(:panties_invisible_category)
  end

  test "should get to products of visible category" do
    get category_products_path(category: categories(:first_visible).title.downcase.downcase.gsub(" ","_"))
    assert_response :success
  end

  test "should not get to products of invisible category" do
    get category_products_path(category: categories(:second_invisible).title.downcase.gsub(" ","_"))
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
