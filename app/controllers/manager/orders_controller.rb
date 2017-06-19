class Manager::OrdersController < ApplicationController
  before_action :set_order, only: :show
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    if params[:status] and Order.statuses.keys.include?(params[:status])
      @orders = Order.by_status(params[:status]).page params[:page]
    else
      @orders = Order.all.page params[:page]
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @order.update(permitted_order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
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

    def set_order
      @order = Order.find(params[:id])
    end

    def permitted_order_params
      params.require(:order).permit(:title, :description, :image, :price)
    end
end
