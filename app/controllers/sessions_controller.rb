class SessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  def new
  end

  def create
    user_params = params["user"]
    @user = User.find_by_email(user_params[:email])
    if @user and @user.authenticate(user_params[:password])
      session[:user_id] = @user.id
    else
      redirect_to new_session_path
    end
      redirect_to users_path
  end
end
