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
    line_items = LineItem.all.map(&:size).map{|size|size.values}.map{|size| size[0]}
    Product.sizes.values.flatten.each do |size|
      @result[:size] << { label: size, value: line_items.count(size) }
    end
  end

  def _set_colors
    @result[:colors] = [ '#E0F2F1', '#B2DFDB', '#80CBC4', '#4DB6AC', '#26A69A','#FFF3E0','#FFE0B2', '#FFCC80','#FFB74D','#FFA726','#FF9800', #Colors for bra sizes
      '#FB8C00','#F57C00','#EF6C00','#E65100','#FF5722'] #Colors for panties sizes
  end

  def _set_empty_result
    @result = {}
  end

end
