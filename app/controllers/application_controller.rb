class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user # makes method available to views

  before_filter :authenticate_user!

  def authenticate_user!
    unless current_user
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
end
