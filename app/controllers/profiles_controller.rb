class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Profile was successfully updated.'
    else
      render :show
    end
  end

  private ######################################################################

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
