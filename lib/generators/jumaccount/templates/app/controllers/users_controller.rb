class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User: #{I18n.t('helpers.saved')}"
    else
      redirect_to users_path, :alert => "User: #{I18n.t('helpers.notsaved')}"
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User: #{I18n.t('helpers.deleted')}"
  end

  private

  def secure_params
    params.require(:user).permit(:user_system_role)
  end

end
