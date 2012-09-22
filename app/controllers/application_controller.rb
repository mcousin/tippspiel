class ApplicationController < ActionController::Base
  protect_from_forgery


  helper_method :current_user # makes method available to views

  before_filter :authenticate_user!
  before_filter :set_time_zone_and_format

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def authenticate_user!
    unless current_user
      redirect_to login_path, notice: "Please login."
    end
  end

  def authenticate_admin!
    unless current_user.admin?
      render_forbidden
    end
  end

  def login!(user, options = {})
    if options[:permanent]
      cookies.permanent['auth_token'] = user.auth_token
    else
      cookies['auth_token'] = user.auth_token
    end
  end

  def logout!
    cookies.delete('auth_token')
  end

  def set_time_zone_and_format
    Time.zone = "Berlin"
    Time::DATE_FORMATS[:default] = "%d.%m. - %H:%M"
  end

  def render_forbidden
    render :file => "#{Rails.root}/public/403", :status => :forbidden, :formats => [:html]
  end

  # needs to be refactored as soon as we have something like a "current_league"
  def update_matches
    return if Rails.env.test?
    league = League.first
    if league.matches.any? {|match| match.has_started? and not match.has_ended}
      league.open_liga_db_league.refresh!
      league.open_liga_db_league.update_matches
    end
  end

end
