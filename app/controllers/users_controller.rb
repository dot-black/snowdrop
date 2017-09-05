class UsersController < StoreController
  def new
    _set_line_items_variables
    @user = User.new
  end

  def create
    user = User.find_or_create_by(email: params[:user][:email])
    if user.valid?
      session[:user_id] = user.id
      session[:user_information_id] = nil
      redirect_to new_user_information_path
    else
      @user = user
      render(:new)
    end
  end
end
