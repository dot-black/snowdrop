require 'active_interaction'

class FetchLineItem < ActiveInteraction::Base
  integer :id

  def execute
    begin
      line_item = LineItem.find id
    rescue ActiveRecord::RecordNotFound
      errors.add(:id, :not_found)
    else
      line_item
    end
  end

end
