class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products_count = {
      total: Product.relevant.count,
      visible: Product.visible.count,
      hiden: Product.hiden.count
    }

    @products_percentage = {
      visible: ( @products_count[:visible].to_f / @products_count[:total].to_f * 100.0 ),
      hiden:  ( @products_count[:hiden].to_f / @products_count[:total].to_f * 100.0 )
    }

    @products_by_categories_count = {}
    Category.all.each do |category|
      @products_by_categories_count[category.title.downcase] = Product.public_send( "category", category.id ).count
    end
  end
end
