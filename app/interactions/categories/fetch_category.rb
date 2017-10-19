require 'active_interaction'

class FetchCategory < ActiveInteraction::Base
  string :category_parameter

  def execute
    Category.find_by_slug category_parameter.gsub("_", " ")
  end
end
