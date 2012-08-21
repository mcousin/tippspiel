class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_admin!,     :only => [:destroy]      


  # GET /home
  def home
    @ranking_first = User.ranking.first
    @ranking_last = User.ranking.first
    @ranking = current_user.ranking_fragment(1)
    
    @matchday = Matchday.current
    if @matchday
      @bets = @matchday.matches.map do |match|
        current_user.bets.find_by_match_id(match.id) || current_user.bets.build(:match => match)
      end
    end
    
  end
  
  
  # GET /signup
  def new
    @user = User.new
  end


  # GET /users
  def index
  end
  
  
  # GET /users/1
  def show
    @user = User.find(params[:id])
  end
  

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Welcome, #{@user.name}!"
    else
      render action: "new"
    end
  end

  
  # GET /profile
  def edit
    @user = current_user
  end


  # PUT /users/1
  def update    
    render_forbidden if User.find_by_id(params[:id]) != current_user
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

    redirect_to users_url
  end
  
  protected 
  
end
