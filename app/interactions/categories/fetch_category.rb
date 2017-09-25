require 'active_interaction'

class FetchCategory < ActiveInteraction::Base
  string :category_parameter

  def execute
    Category.where(['lower(title) = ?', category_parameter.gsub("_", " ")]).take
  end
end
