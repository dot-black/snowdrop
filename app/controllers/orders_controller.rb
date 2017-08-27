class OrdersController < StoreController
  def new
    _ensure_cart_isnt_empty
    @order = Order.new
  end


  def create
    @order = Order.new _permitted_order_params
    @order.add_line_items_from_cart @cart
    @order.amount = GetLineItemsTotalAmount.run!(line_items: @order.line_items)

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
