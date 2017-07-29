require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def new_product
    Product.new(
      title: "My Product Title",
      description: "My product description",
      price: 22.99,
      category_id: Category.first.id,
      sizes: Product.sizes[:standard]
    )
  end

    test "product attributes must not be empty" do
      product = Product.new
      assert product.invalid?
      assert product.errors[:title].any?
      assert product.errors[:description].any?
      assert product.errors[:price].any?
      assert product.errors[:sizes].any?
    end

    test "product price must be positive" do
      product = self.new_product
      product.price = -1
      assert product.invalid?
      product.errors[:price]
      product.price = 0
      assert product.invalid?
      product.errors[:price]
      product.price = 1
      assert product.valid?
    end
end
