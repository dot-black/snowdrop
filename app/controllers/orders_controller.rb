class OrdersController < StoreController
  before_action :_ensure_session_for_user_presisted, only:[:new, :create]
  def new
    _ensure_cart_isnt_empty
    _set_user
    @order = Order.new
  end


  def create
    _set_user
    @order = @user.orders.new _permitted_order_params
    @order.add_line_items_from_cart @cart
    @order.amount = GetLineItemsTotalAmount.run!(line_items: @order.line_items)

    respond_to do |format|
      if @order.save
        DestroyCart.run! session: session
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
      params.require(:order).permit( :comment )
    end

    def _ensure_session_for_user_presisted
      redirect_to new_user_path unless session[:user_id].present?
    end
    def _set_user
      outcome = FetchUser.run(id: session[:user_id])
      if outcome.valid?
        @user = outcome.result
      else
        raise ActiveRecord::RecordNotFound,outcome.errors.full_messages.to_sentence
        redirect_to new_user_path
      end
    end
end
