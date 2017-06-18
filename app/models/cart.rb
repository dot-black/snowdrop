class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product,quantity)
    current_item = line_items.find_by(product_id: product.id)
    current_item ? current_item.quantity += quantity : current_item = line_items.build(product_id: product.id)
    current_item
  end
end
