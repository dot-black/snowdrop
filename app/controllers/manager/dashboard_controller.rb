class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products_count = {
      total: Product.relevant.count,
      visible: Product.visible.count,
      hidden: Product.hidden.count
    }

    @products_percentage = {
      visible: ( @products_count[:visible].to_f / @products_count[:total].to_f * 100.0 ),
      hidden:  ( @products_count[:hidden].to_f / @products_count[:total].to_f * 100.0 )
    }

    @products_by_categories_count = {}
    Category.all.each do |category|
      @products_by_categories_count[category.title.downcase] = Product.public_send( "category", category.id ).count
    end

    @orders_count = {
      total: Order.count,
      pending: Order.where(status: "pending").count,
      accepted: Order.where(status: "accepted").count,
      completed: Order.where(status: "completed").count,
      declined: Order.where(status: "declined").count
    }

    @orders_percentage = {
      pending: ( @orders_count[:pending].to_f / @orders_count[:total].to_f * 100.0 ),
      accepted: ( @orders_count[:accepted].to_f / @orders_count[:total].to_f * 100.0 ),
      completed: ( @orders_count[:completed].to_f / @orders_count[:total].to_f * 100.0 ),
      declined: ( @orders_count[:declined].to_f / @orders_count[:total].to_f * 100.0 )
    }
  end
end
