class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products_count = {
      total: Product.count,
      visible: Product.visible.count,
      hiden: Product.hiden.count
    }

    @products_percentage = {
      visible: ( @products_count[:visible].to_f / @products_count[:total].to_f * 100.0 ),
      hiden:  ( @products_count[:hiden].to_f / @products_count[:total].to_f * 100.0 )
    }

    @products_by_categories_count = {}
    Product.categories.each do |key, value|
      @products_by_categories_count[key] = Product.public_send(key).count
    end
  end
end
