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
  test "should include appropriate products for client" do
    assert Product.shown.map(&:archive).include? false
    assert Product.shown.map(&:visible).include? true
    Category.where(visible: true).ids.each do |id|
      assert Product.shown.map(&:category_id).include? id
    end
  end

  test "should exclude inappropriate products for client" do
    assert Product.shown.map(&:archive).exclude? true
    assert Product.shown.map(&:visible).exclude? false
    Category.where(visible: false).ids.each do |id|
      assert Product.shown.map(&:category_id).exclude? id
    end
  end

  test "should include appropriate products by categories for client" do
    Category.all.ids.each do |category_id|
      assert Product.by_category(category_id).map(&:archive).include? false
      assert Product.by_category(category_id).map(&:visible).include? true
      Product.where(category_id: category_id, visible: true, archive: false).ids.each do |id|
        assert Product.by_category(category_id).map(&:id).include? id
      end
    end
  end

  test "should exclude inappropriate products by categories for client" do
    Category.all.ids.each do |id|
      assert Product.by_category(id).map(&:archive).exclude? true
      assert Product.by_category(id).map(&:visible).exclude? false
    end
  end
  test "should include relevant products for manager" do
    assert Product.relevant.map(&:archive).include? false
  end

  test "should exlude not relevant products for manager" do
    assert Product.relevant.map(&:archive).exclude? true
  end

  test "should include archival products for manager" do
    assert Product.archival.map(&:archive).include? true
  end

  test "should exlude not archival products for manager" do
    assert Product.archival.map(&:archive).exclude? false
  end

  test "should include visible products for manager" do
    assert Product.visible.map(&:visible).include? true
  end

  test "should exlude not visible products for manager" do
    assert Product.visible.map(&:visible).exclude? false
  end

  test "should include hidden products for manager" do
    assert Product.hidden.map(&:visible).include? false
  end

  test "should exlude not hidden products for manager" do
    assert Product.hidden.map(&:visible).exclude? true
  end

  test "should include relevant products by category" do
    Category.all.ids.each do |category_id|
      assert Product.manager_category(category_id).map(&:archive).include? false
      Product.where(category_id: category_id, archive: false).ids.each do |id|
        assert Product.manager_category(category_id).map(&:id).include? id
      end
    end
  end
  test "should exclude not relevant products by category" do
    Category.all.ids.each do |category_id|
      assert Product.manager_category(category_id).map(&:archive).exclude? true
    end
  end
end
