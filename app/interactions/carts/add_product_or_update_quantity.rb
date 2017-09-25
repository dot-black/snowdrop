require 'active_interaction'

class AddProductOrUpdateQuantity < ActiveInteraction::Base
  interface :session
  interface :line_item_params

  def execute
    cart = GetCart.run! session: session
    current_item = cart.line_items.find_by_product_id_and_size line_item_params[:product_id], line_item_params[:size]
    if current_item.present?
      current_item.quantity += line_item_params[:quantity] ? line_item_params[:quantity].to_i : 1
    else
      current_item = cart.line_items.build( product_id: line_item_params[:product_id], size: line_item_params[:size] )
    end
    current_item
  end

end
