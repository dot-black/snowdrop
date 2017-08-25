require 'active_interaction'

class GetCategoriesStatistics < ActiveInteraction::Base
  symbol :scope_for_product, default: :manager_category

  def execute
    hash = {}
    Category.all.each do |category|
      hash[category.title.downcase] = {
        count: Product.public_send(scope_for_product.to_s, category.id ).count,
        id: category.id
      }
    end
    hash
  end

end
