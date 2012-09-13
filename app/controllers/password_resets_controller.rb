class PasswordResetsController < ApplicationController

  skip_before_filter :authenticate_user!

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to login_path, :notice => "Email sent with password reset instructions."
  end

end
