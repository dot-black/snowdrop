require 'active_interaction'

class SetLineChart < ActiveInteraction::Base

  def execute
    _set_empty_result
    _get_month_names
    _get_label
    _get_total_count
    @result
  end
  private

  def _set_empty_result
    @result = {}
  end

  def _get_total_count
    @result[:orders] = []
    orders = Order.group("orders.created_at::date").count
    (1.month.ago.to_date..Date.today).each do |date|
       @result[:orders] << { x: date.strftime("%Y-%m-%d"), y: orders.key?(date) ? orders[date] : 0 }
    end
  end

  def _get_month_names
    @result[:month_names] = I18n.translate('date.abbr_month_names')
  end

  def _get_label
    @result[:label] = I18n.translate 'manager.layout.orders_count'
  end
end
