class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_admin!,     :only => [:destroy]      


  # GET /home
  def home
    @users = User.all.sort{|a,b| b.points <=> a.points}
    @ranking = User.get_ranking
    
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
    @ranking = User.get_ranking
    @users = User.all.sort{|a,b| b.points <=> a.points}
  end
  
  
  # GET /users/1
  def show
    @user = User.find(params[:id])
  end
  

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
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
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
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
