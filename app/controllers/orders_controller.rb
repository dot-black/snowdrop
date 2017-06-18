class OrdersController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: [:new, :create ]
  before_action :_ensure_cart_isnt_empty, only: :new

  def new
    @order = Order.new
    @payment_methods = Order.payment_methods.keys
  end


  def create
    @order = Order.new(_permitted_order_params)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to store_path}
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def _permitted_order_params
    params.require(:order).permit(:name, :payment_method, :comment )
  end

end
