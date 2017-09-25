require 'active_interaction'

class GetVisualStatistics < ActiveInteraction::Base

  def execute
    hash = {}
    hash[:orders_total_count] = _get_total_count(from = 2.weeks.ago.to_date, to = Date.today)
    hash[:line_items_category_count] = _get_line_items_category_count
    hash[:line_items_sizes_count] = _get_line_items_sizes_count
    hash[:colors] = _default_colors

    hash
  end
  private

  def _get_total_count(from, to)
    hash = {}
    (from..to).map{ |date| date.strftime("%Y-%m-%d") }.each do |date|
      hash[date] = Order.where(created_at: Date.parse(date).midnight..Date.parse(date).end_of_day).count
    end
    hash
  end

  def _get_line_items_category_count
    hash = {}
    Category.all.each do |category|
      hash[category.title] = LineItem.where(product_id: Product.where(category_id: category.id).map(&:id)).count
    end
    hash
  end

  def _get_line_items_sizes_count
    hash = {}
    Product.sizes.values.flatten.each do |size|
      hash[size] = LineItem.all.map(&:size).map{|size|size.values}.map{|size| size[0]}.count(size)
    end
    hash
  end
  def _default_colors
    [ '#E0F2F1', '#B2DFDB', '#80CBC4', '#4DB6AC', '#26A69A','#FFF3E0','#FFE0B2', '#FFCC80','#FFB74D','#FFA726','#FF9800', #Bra sizes
      '#FB8C00','#F57C00','#EF6C00','#E65100','#FF5722' #Standard sizes
    ]
  end
end
