class UsersController < StoreController
  before_action :_set_cart_variables, :_set_categories

  def new
    @user = User.new
  end

  def create
    user = User.find_or_create_by _permitted_user_params
    if user.valid?
      session[:user_id] = user.id
      session[:user_information_id] = nil
      redirect_to new_user_information_path
    else
      @user = user
      render :new
    end
  end

  private

  def _permitted_user_params
    params.require(:user).permit :email
  end
end
