class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products_count = Product.count
    @orders_count = Order.count
  end
end
