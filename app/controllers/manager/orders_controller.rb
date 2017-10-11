class Manager::OrdersController < ApplicationController
  before_action :_set_order, only: [:show, :update]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    unless params[:status].present? and Order.statuses.keys.push("all").include? params[:status]
      flash[:notice] = params[:status].present? ? (t 'manager.orders.flash.index.prohibited') : (t 'manager.orders.flash.index.absent')
      redirect_to manager_dashboard_path
    end
    @current_status = params[:status]
    @orders = Order.filter_by_status(@current_status).search_by_name_or_email_or_telephone(params[:search_query]).page params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @current_status = @order.status
  end

  def update
    @send_email = params[:send_email] == "Send email" ? true : false
    respond_to do |format|
      if @order.update(_permitted_order_params)
        OrderMailer.manager_information(@order).deliver
        OrderMailer.client_confirmation(@order).deliver if @send_email
        format.html { redirect_to manager_orders_path(status: _permitted_order_params[:status]), notice: (t 'manager.orders.flash.update.success')}
      else
        format.html { render :edit }
        flash.now.notice = (t 'manager.orders.flash.update.failure')
      end
    end
  end

  # def destroy
  #   @order.destroy
  #   respond_to do |format|
  #     format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

private
  def _set_order
    @order = Order.find(params[:id])
  end

  def _permitted_order_params
    params.require(:order).permit(:title, :description, :image, :price, :status)
  end
end
