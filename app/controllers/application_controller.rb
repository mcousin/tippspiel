class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user # makes method available to views

  before_filter :authenticate_user!


  def authenticate_user!
    unless current_user
      redirect_to login_path, notice: "Please login."
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  def authenticate_admin!
    unless current_user.admin?
      render_forbidden
    end
  end
  
  def render_forbidden
    render :file => "#{Rails.root}/public/403.html", :status => :forbidden
  end
end
