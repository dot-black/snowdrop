class OrdersController < ApplicationController
  include CurrentCart
  include Categories

  def new
    _set_categories
    _set_cart
    _ensure_cart_isnt_empty
    _set_line_items_variables
    @order = Order.new
  end


  def create
    _set_categories
    _set_cart
    @order = Order.new _permitted_order_params
    @order.add_line_items_from_cart @cart
    @order.amount = _get_line_items_amount @order.line_items

    respond_to do |format|
      if @order.save
        _destroy_cart
        OrderMailer.manager_information(@order).deliver
        OrderMailer.client_information(@order).deliver
        format.html { render 'successful_order' }
        format.json { render :show, status: :created, location: @order }
      else
        flash[:notice] = "Order wasn't created, please fill in all the fields correctly."
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
