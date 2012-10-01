class PasswordResetsController < ApplicationController

  skip_before_filter :authenticate_user!

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to login_path, notice: "Email sent with password reset instructions."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if (not @user.password_reset_sent_at) || (@user.password_reset_sent_at < 2.hours.ago)
      redirect_to new_password_reset_path, notice: "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to login_path, notice: "Password has been reset."
    else
      render :edit
    end
  end

end
