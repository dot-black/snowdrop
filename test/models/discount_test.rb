require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  def new_discount
    Discount.new title: "Test discount", value: 10
  end

  test "discount should not be created without title" do
    discount = new_discount
    discount.title = ""
    assert discount.invalid?
    discount.errors[:title]
    discount.title = "New discount"
    assert discount.valid?
  end

  test "discount should not be created without value" do
    discount = new_discount
    discount.value = ""
    assert discount.invalid?
    discount.errors[:value]
    discount.value = 10
    assert discount.valid?
  end

  test "discount value should be form 0 to 100" do
    discount = new_discount
    discount.value = 0
    assert discount.invalid?
    discount.errors[:value]
    discount.value = 100
    assert discount.invalid?
    discount.errors[:value]
    discount.value = 1
    assert discount.valid?
    discount.value = 99
    assert discount.valid?
  end

end
