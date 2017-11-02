class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products   = GetScopeStat.run!({ scopes:[:visible, :hidden], model: Product, scope_for_total: :relevant })
    @orders     = GetScopeStat.run!({ scopes: Order.statuses.keys.map(&:to_sym), model: Order })
    @categories = GetCategoriesStat.run!
  end

  def chart_statistics
    render json: { line: SetLineChart.run!, donut: SetDonutChart.run! }
  end
end
