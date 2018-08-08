class UserInformationsController < StoreController
  before_action :_ensure_session_and_user_present
  before_action :_set_cart_variables, :_set_categories

  def new
    @user_information = @user.user_informations.new
  end

  def create
    user_information = @user.user_informations.find_or_create_by _permitted_user_information_params
    if user_information.valid?
      session[:user_information_id] = user_information.id
      redirect_to new_order_path
    else
      @user_information = user_information
      render :new
    end
  end

  private

  def _permitted_user_information_params
    params.require(:user_information).permit(:name, :telephone)
  end

  def _ensure_session_and_user_present
    @user = User.find_by(id: session[:user_id])
    redirect_to new_user_path unless @user
  end
end
