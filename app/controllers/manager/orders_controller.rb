class Manager::OrdersController < ApplicationController
  before_action :authenticate_manager!
  before_action :_ensure_order_present, only: [:show, :update]
  layout 'managers/dashboard'

  def index
    if params[:status].present? && Order.statuses.keys.exclude?(params[:status])
      redirect_to manager_orders_path, notice: t('manager.orders.flash.index.prohibited')
    else
      @current_status = params[:status]
      @orders = Order.filter(_filtering_params)
                     .search_by_name_or_email_or_telephone(params[:search_query])
                     .page params[:page]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def show; end

  def update
    respond_to do |format|
      if @order.update _permitted_order_params
        OrderMailer.manager_information(@order).deliver
        OrderMailer.client_confirmation(@order).deliver if params[:notification]
        format.html do
          redirect_to manager_orders_path(status: _permitted_order_params[:status]),
                      notice: t('manager.orders.flash.update.success')
        end
      else
        flash.now.notice = t('manager.orders.flash.update.failure')
        format.html { render :edit }
      end
    end
  end

  private

  def _ensure_order_present
    @order = Order.find_by(id: params[:id])
    redirect_to manager_order_path unless @order
  end

  def _permitted_order_params
    params.require(:order).permit(:title, :description, :image, :price, :status)
  end

  def _filtering_params
    params.slice(:status)
  end

end
