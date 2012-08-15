class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :verify_permission!,      :only => [:edit, :update, :destroy]

  # GET /users
  def index
    @ranking = User.get_ranking
    @users = User.all.sort{|a,b| b.points <=> a.points}
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    
    @users = User.all.sort{|a,b| b.points <=> a.points}
    @ranking = User.get_ranking
    
    @matchday = Matchday.current
    if @matchday
      @bets = @matchday.matches.map do |match|
        @user.bets.find_by_match_id(match.id) || @user.bets.build(:match => match)
      end
    end
    
  end
  

  # GET /users/new
  def new
    @user = User.new
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

  #################################
  #        LIMITED ACCESS         #
  # (user can only edit himself)  #
  #################################

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end
  
  protected 
  
  def verify_permission!
    unless current_user.id == params[:id].to_i || current_user.admin?
      render_forbidden
    end    
  end
end
