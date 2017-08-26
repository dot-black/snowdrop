require 'active_interaction'

class FetchLineItem < ActiveInteraction::Base
  integer :id

  def execute
    line_item = LineItem.find id
    errors.add(:id, :not_found) unless line_item
    line_item
  end
  
end
