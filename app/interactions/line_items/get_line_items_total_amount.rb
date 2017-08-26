require 'active_interaction'

class GetLineItemsTotalAmount < ActiveInteraction::Base
  interface :line_items

  def execute
    line_items.present? ? _count_total_amount : 0
  end

  private
  
  def _get_prices
    line_items.map(&:product).map(&:price)
  end

  def _get_quantities
    line_items.map(&:quantity)
  end

  def _count_total_amount
    _get_prices.zip(_get_quantities).map{|x, y| x * y }.inject(0, &:+)
  end

end
