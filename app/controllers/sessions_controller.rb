class SessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  # GET /login/
  def new
  end

  # POST /session/
  def create
    user_params = params["user"]
    user = User.find_by_email(user_params["email"])
    if user and user.authenticate(user_params["password"])
      login!(user, permanent: user_params["remember_me"] == "1")
      redirect_to home_path, notice: "Welcome back, #{user.name}!"
    else
      flash.notice = "Invalid credentials!"
      render action: "new"
    end
  end

  # DELETE /logout/
  def destroy
    logout!
    redirect_to login_path, notice: "You were successfully logged out."
  end

end
