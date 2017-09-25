class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index

    @products = GetPercentageStatistics.run!({ scopes:[:visible, :hidden], model: Product, scope_for_total: :relevant})
    @orders = GetPercentageStatistics.run!({ scopes: Order.statuses.keys, model: Order})
    @categories = GetCategoriesStatistics.run!
    @visual_statistics = GetVisualStatistics.run!
  end
end
