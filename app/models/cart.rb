class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product line_item
    current_item = line_items.find_by(product_id: line_item[:product_id])
    current_item ? current_item.quantity += line_item[:quantity] : current_item = line_items.build(product_id: line_item[:product_id], size: Product.sizes.key(line_item[:size].to_i))
    current_item
  end
end
