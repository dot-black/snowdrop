require 'active_interaction'

class FetchCategory < ActiveInteraction::Base
  string :category_parameter

  def execute
    param = category_parameter.tr("_", " ")
    Category.find_by(slug: param) ||
      Translation.find_by(translateable_type: "Category", attribute_name: "slug", value: param)
                 .try(:translateable)
  end
end
