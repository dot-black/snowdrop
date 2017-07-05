require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:third_to_delete)
    @image = Rails.root.join("test/fixtures/files/image.png").open
  end
  def new_order
    Category.new title: "Test categoty", image: @image
  end

  test "category should not be created without title" do
    category = new_order
    category.title = ""
    assert category.invalid?
    category.errors[:title]
    category.title = "New category"
    assert category.valid?
  end

  test "category should not be created without image" do
    category = new_order
    category.image = nil
    assert category.invalid?
    category.errors[:image]
    category.image = @image
    assert category.valid?
  end

  test "products should be destoyed if category is destroyed" do
    assert_difference 'Product.count', -@category.products.count do
      @category.destroy
    end
  end
end
