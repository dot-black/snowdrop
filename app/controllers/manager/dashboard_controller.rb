class Manager::DashboardController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @products = {
      count: {
        total: Product.relevant.count,
        visible: Product.visible("true").count,
        hidden:Product.hidden("true").count
      },
      percentage: {
        visible: Product.visible("true").count.to_f / Product.relevant.count.to_f * 100.0,
        hidden: Product.hidden("true").count.to_f / Product.relevant.count.to_f * 100.0,
      },
      categories:{}
    }

    Category.all.each do |category|
      @products[:categories][category.title.downcase] = {
        count: Product.public_send( "manager_category", category.id ).count,
        id: category.id
      }
    end

    uniq_dates = Order.all
    @orders = {
      count:{
        total: Order.count,
        pending: Order.where(status: "pending").count,
        accepted: Order.where(status: "accepted").count,
        completed: Order.where(status: "completed").count,
        declined: Order.where(status: "declined").count
      },
      percentage:{
        pending: Order.where(status: "pending").count.to_f / Order.count.to_f * 100.0,
        accepted: Order.where(status: "accepted").count.to_f / Order.count.to_f * 100.0,
        completed: Order.where(status: "completed").count.to_f / Order.count.to_f * 100.0,
        declined: Order.where(status: "declined").count.to_f / Order.count.to_f * 100.0
      },
      statistics:{
        total_count: {},
        line_items_category_count: {},
        line_items_sizes_count: {},
        colors: ['#E0F2F1', '#B2DFDB', '#80CBC4', '#4DB6AC', '#26A69A', '#FFF3E0','#FFE0B2', '#FFCC80','#FFB74D','#FFA726','#FF9800','#FB8C00','#F57C00','#EF6C00','#E65100','#FF5722']
      }
    }
    #Orders total count statistics
    (2.weeks.ago.to_date..Date.today).map{ |date| date.strftime("%Y-%m-%d") }.each do |date|
       @orders[:statistics][:total_count][date] = Order.where(created_at: Date.parse(date).midnight..Date.parse(date).end_of_day).count
    end
    #Orders line items statistics by categories
    Category.all.each do |category|
      @orders[:statistics][:line_items_category_count][category.title] = LineItem.where(product_id: Product.where(category_id: category.id).map(&:id)).count
    end
    #Ordrs line items statistics by sizes
    Product.sizes.values.flatten.each do |size|
      @orders[:statistics][:line_items_sizes_count][size] = LineItem.all.map(&:size).map{|size|size.values}.map{|size| size[0]}.count(size)
    end
  end
end
