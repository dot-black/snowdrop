class Manager::UsersController < ApplicationController
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @users = User.search_by_name_or_email_or_telephone(params[:search_query]).page params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    redirect_to users_path unless params[:id].present? and _set_user
  end

private

  def _set_user
    @user = User.find_by_id params[:id]
  end

end
