class UserInformationsController < StoreController
  before_action :_ensure_user_session_and_user_present
  def new
    _set_line_items_variables
    _set_user
    @user_information = @user.user_informations.new
  end

  def create
    _set_user
    user_information = @user.user_informations.find_or_create_by(
      name: params[:user_information][:name],
      telephone: params[:user_information][:telephone])
    if user_information.valid?
      session[:user_information_id] = user_information.id
      redirect_to new_order_path
    else
      @user_information = user_information
      render(:new)
    end
  end

  private
  def _ensure_user_session_and_user_present
    redirect_to new_user_path unless session[:user_id].present? and User.find_by_id(session[:user_id]).present?
  end
  def _set_user
    @user = User.find session[:user_id]
    redirect_to new_user_path unless @user.present?
  end
end
