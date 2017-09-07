class Manager::UsersController < ApplicationController
  before_action :_set_user, only: [:show, :update]
  before_action :authenticate_manager!
  layout 'managers/dashboard'

  def index
    @search_query = params[:search_query]
    @users = if @search_query.present?
      User.joins(:user_informations).where(
        "lower(users.email) like lower('#{@search_query}%')
        or user_informations.telephone like '#{@search_query}%'
        or lower(user_informations.name) like lower('#{@search_query}%')"
      ).page params[:page]
    else
      User.all.page params[:page]
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  # def update
  #   respond_to do |format|
  #     if @user.update(_permitted_user_params)
  #       format.html { redirect_to manager_users_path, notice: "User has been successfuly updated."}
  #       format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

    def _set_user
      @user = User.find(params[:id])
    end

    # def _permitted_user_params
    #   params.require(:user).permit(:name, :email, :telephone)
    # end
end
