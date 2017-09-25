class OrdersController < StoreController
  before_action :_ensure_session_for_user_presisted, only:[:new, :create]
  before_action :_set_user, :_set_user_information, only:[:new, :create]
  def new
    if @line_items.empty?
      flash[:notice] = t 'orders.falsh.new.empty_cart'
      redirect_to store_path
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
        OrderMailer.manager_information(@order).deliver
        OrderMailer.client_information(@order).deliver
        format.html { render 'successful_order' }
        format.json { render :show, status: :created, location: @order }
      else
        flash[:notice] = t 'orders.falsh.create.failure'
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
      if session[:user_id].present?
        redirect_to new_user_information_path unless session[:user_information_id].present?
      else
        redirect_to new_user_path
      end
    end

    def _set_user
      @user = User.find_by_id session[:user_id]
      redirect_to new_user_path unless @user
    end
    def _set_user_information
      @user_information = UserInformation.find session[:user_information_id]
      redirect_to new_user_information_path unless @user_information.present?
    end
end
