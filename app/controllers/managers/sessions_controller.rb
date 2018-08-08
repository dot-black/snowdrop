class Managers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout 'managers/manager'
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if current_manager
      redirect_to manager_dashboard_path
      flash[:notice] = I18n.t('devise.sessions.signed_in')
    else
      flash[:error] = I18n.t('devise.sessions.error')
      redirect_to new_manager_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    return unless sign_out(current_manager)
    redirect_to new_manager_session_path
    flash[:notice] = I18n.t('devise.sessions.signed_out')
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
