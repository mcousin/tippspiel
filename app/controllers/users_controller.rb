class UsersController < ApplicationController

  skip_before_filter :authenticate_user!,  :only => [:new, :create]
  before_filter :authenticate_admin!,      :only => [:destroy]
  before_filter :update_matches,           :only => [:home, :index]


  # GET /home
  def home
    @ranking = Ranking.new(User.all).fragment_for(current_user)
    @matchday = Matchday.current
    @bets = current_user.find_or_build_bets_for_matchday(@matchday) if @matchday
  end


  # GET /signup
  def new
    @user = User.new
  end


  # GET /users
  def index
    @ranking = Ranking.new(User.all)
  end


  # GET /users/1
  def show
    @user = User.find(params[:id])
  end


  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      login!(@user)
      redirect_to home_path, notice: "Welcome, #{@user.name}!"
    else
      render action: "new"
    end
  end


  # GET /profile
  def edit
    @user = current_user
  end


  # PUT /profile
  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      redirect_to profile_path, notice: 'Your profile was successfully updated.'
    else
      render action: "edit"
    end
  end


  #################################
  #         ADMINS ONLY           #
  #################################

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url, notice: 'The user was successfully destroyed.'
  end

  protected

end
