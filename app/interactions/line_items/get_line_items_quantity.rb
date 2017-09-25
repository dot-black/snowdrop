require 'active_interaction'

class GetLineItemsQuantity < ActiveInteraction::Base
  interface :line_items

  def execute
    line_items.present? ? _count_quantity : 0
  end

  private

  def _count_quantity
    line_items.sum(:quantity)
  end

end
