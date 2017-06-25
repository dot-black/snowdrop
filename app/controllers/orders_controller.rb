class OrdersController < ApplicationController
  include CurrentCart
  before_action :_set_cart, only: [:new, :create ]
  before_action :_ensure_cart_isnt_empty, only: :new

  def new
    _set_cart_line_items
    _set_cart_counter @line_items
    @order = Order.new
  end


  def create
    @order = Order.new _permitted_order_params
    @order.add_line_items_from_cart @cart
    @order.amount = _get_line_items_amount @order.line_items

    respond_to do |format|
      if @order.save
        _destroy_cart
        flash[:notice] = "Thank you for your order!"
        format.html { redirect_to store_path }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def _permitted_order_params
      params.require(:order).permit(:name, :email, :telephone, :comment )
    end
end
