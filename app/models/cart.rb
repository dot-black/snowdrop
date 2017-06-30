class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product line_item
    current_item = line_items.find_by_product_id_and_size line_item[:product_id], line_item[:size]
    if current_item
      current_item.quantity += line_item[:quantity] ? line_item[:quantity].to_i : 1
    else
      current_item = line_items.build( product_id: line_item[:product_id], size: line_item[:size] )
    end
    current_item
  end

end
