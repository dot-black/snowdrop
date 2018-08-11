require 'active_interaction'

class SetDonutChart < ActiveInteraction::Base

  def execute
    _set_empty_result
    _set_colors
    _set_category_statistics
    _set_size_statistics
    @result
  end

  private

  def _set_category_statistics
    @result[:category] = []

    Category.all.each do |category|
      @result[:category] << { label: category.title, value: category.products.joins(:line_items).count }
    end
  end

  def _set_size_statistics
    @result[:size] = []
    line_items = LineItem.all.map { |li| li.size.values.first }
    Product.sizes.values.flatten.each do |size|
      @result[:size] << { label: size, value: line_items.count(size) }
    end
  end

  def _set_colors
    @result[:colors] = [
      # Colors for panties sizes
      '#E0F2F1', # XS
      '#B2DFDB', # S
      '#80CBC4', # M
      '#4DB6AC', # L
      '#26A69A', # XL
      # Colors for bra sizes
      '#FFF3E0', # 70A
      '#FFE0B2', # 70B
      '#FFCC80', # 70C
      '#FFB74D', # 75A
      '#FFA726', # 75B
      '#FF9800', # 75C
      '#FB8C00', # 75D
      '#F57C00', # 80B
      '#EF6C00', # 80C
      '#E65100', # 85B
      '#FF5722'  # 85C
    ]
  end

  def _set_empty_result
    @result = {}
  end

end
