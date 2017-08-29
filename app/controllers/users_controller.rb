class UsersController < StoreController
  before_action :_redirect_unless_user_session, only: [:edit, :update]
  def new
    @user = CreateUser.new
  end

  def create
    outcome = CreateUser.run(params.fetch(:user, {}))
    if outcome.valid?
      session[:user_id] = outcome.result.id
      redirect_to new_order_path
    else
      @user = outcome
      if _user_already_exists?
        session[:user_id] = _found_user_by_email(@user.email).id
        flash[:notice] = "Such user exists! Do you want to update informatiom?"
        redirect_to edit_users_path
      else
        render(:new)
      end
    end
  end

  def edit
    user = find_user!
    @user = UpdateUser.new(user: user, name: user.name, email: user.email, telephone: user.telephone)
  end

  def update
    inputs = params.fetch(:update_user, {}).merge(user: find_user!)

    outcome = UpdateUser.run(inputs)
    if outcome.valid?
      redirect_to new_order_path
    else
      @user = outcome
      render(:edit)
    end
  end

  private

  def find_user!
    outcome = FetchUser.run(id: session[:user_id])
    if outcome.valid?
      outcome.result
    else
      raise ActiveRecord::RecordNotFound,outcome.errors.full_messages.to_sentence
    end
  end

  def _found_user_by_email(email)
    CheckUserByEmail.run! email: email
  end

  def _user_already_exists?
    @user.email.present? and _found_user_by_email(@user.email).present?
  end

  def _redirect_unless_user_session
     unless session[:user_id].present?
       flash[:notice] = "Please enter your information first"
       redirect_to new_user_path
     end
  end
end
