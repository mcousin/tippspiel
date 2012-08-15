class SessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  def new
  end

  def create
    user_params = params["user"]
    @user = User.find_by_email(user_params["email"])
    if @user and @user.authenticate(user_params["password"])
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to login_path, notice: "Invalid credentials!" 
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
