class OrdersController < StoreController
  before_action :_set_cart_variables, :_set_categories
  before_action :_ensure_user_presisted, :_ensure_user_information_presisted

  def new
    if @cart.line_items.empty?
      redirect_to store_path, notice: t('orders.flash.new.empty_cart')
    else
      @order = Order.new
    end
  end

  def create
    @order = @user.orders.new _permitted_order_params
    @order.user_information = @user_information
    AddLineItemsFromCart.run! session: session, order: @order
    @order.amount = GetLineItemsTotalAmount.run!(line_items: @order.line_items)

    respond_to do |format|
      if @order.save
        DestroyCart.run! session: session
        ManagerMailWorker.perform_async @order.id
        ClientMailWorker.perform_async @order.id
        format.html { render 'successful_order' }
      else
        flash[:notice] = t 'orders.falsh.create.failure'
        format.html { render :new }
      end
    end
  end

  private

  def _permitted_order_params
    params.require(:order).permit(:comment, :locale)
  end

  def _ensure_user_presisted
    @user = User.find_by(id: session[:user_id])
    redirect_to new_user_path unless @user
  end

  def _ensure_user_information_presisted
    @user_information = UserInformation.find_by(id: session[:user_information_id])
    redirect_to new_user_information_path unless @user_information
  end

end
