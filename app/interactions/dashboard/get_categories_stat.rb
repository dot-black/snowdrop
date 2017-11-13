require 'active_interaction'

class GetCategoriesStat < ActiveInteraction::Base
  symbol :scope_for_product, default: :manager_category

  def execute
    _set_empty_result
    _set_products_count_for_each_category
    @result
  end

private
  def _set_empty_result
    @result = {}
  end

  def _set_products_count_for_each_category
    Category.all.each do |category|
      @result[category.title.downcase] = {
        count: Product.public_send(scope_for_product, category.id).count,
        id: category.id
      }
    end
  end
end
