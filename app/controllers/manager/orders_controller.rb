class Manager::OrdersController < ApplicationController
  before_action :_set_order, only: [:show, :update]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    unless params[:status].present?
      flash[:notice] = "Parameter status must be present!"
      redirect_to manager_dashboard_path
    end
    @current_status = params[:status]
    @search_query = params[:search_query]

    @orders = if @search_query.present?
      Order.by_status(params[:status]).where("lower(email) like lower('#{@search_query}%') or telephone like '#{@search_query}%' ").page params[:page]
    else
      Order.by_status(params[:status]).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @current_status = @order.status
  end

  def edit
  end

  def update
    @send_email = params[:send_email]
    respond_to do |format|
      if @order.update(_permitted_order_params)
        OrderMailer.manager_information(@order).deliver
        OrderMailer.client_confirmation(@order).deliver if @send_email
        format.html { redirect_to manager_order_path(status: "all")}
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
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
