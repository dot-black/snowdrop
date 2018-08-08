class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    _get_products
    _get_orders
    _get_categories
  end

  def chart_statistics
    render json: { line: SetLineChart.run!, donut: SetDonutChart.run! }
  end

  private

  def _get_products
    outcome = GetScopeStat.run scopes: [:visible, :hidden],
                               model: Product,
                               scope_for_total: :relevant
    @products = outcome.valid? ? outcome.result : nil
  end

  def _get_orders
    outcome = GetScopeStat.run scopes: Order.statuses.keys.map(&:to_sym),
                               model: Order
    @orders = outcome.valid? ? outcome.result : nil
  end

  def _get_categories
    outcome = GetCategoriesStat.run
    @categories = outcome.valid? ? outcome.result : nil
  end

end
