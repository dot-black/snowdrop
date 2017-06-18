class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product line_item
    current_item = line_items.find_by_product_id_and_size line_item[:product_id], _get_size( line_item[:size].to_i )
    if current_item
      current_item.quantity += line_item[:quantity].to_i
    else
      current_item = line_items.build( product_id: line_item[:product_id], size: _get_size( line_item[:size].to_i ))
    end   
    current_item
  end

  private
  def _get_size id
    Product.sizes.key(id)
  end
end
