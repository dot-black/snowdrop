require 'active_interaction'

class GetPercentageStatistics < ActiveInteraction::Base
  array :scopes { symbol }
  interface :model
  symbol :scope_for_total, default: :all

  validates :scopes,
    presence: true

  def execute
    hash = { count: {}, percentage: {} }
    hash[:count][:total] = count_for_total = model.public_send(scope_for_total).count
    scopes.each do |key,value|
      hash[:count][key] = count_for_key = model.public_send(key).count
      hash[:percentage][key] = count_for_key.to_f / count_for_total.to_f * 100.0
    end
    hash
  end

end
