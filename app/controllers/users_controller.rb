class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :verify_permission_for_id,  :only => [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @ranking = User.get_ranking
    @users = User.all.sort{|a,b| b.points <=> a.points}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @users = User.all.sort{|a,b| b.points <=> a.points}

    @matchday = Matchday.find(1)
    @started_matches = @matchday.matches.select{|match| match.started?}
    @matches_to_bet = @matchday.matches - @started_matches
    @ranking = User.get_ranking
    
    # find bet for each match of matchday if any, otherwise create new one
    @bets = @matches_to_bet.map do |match| 
      current_user.bets.find_by_match_id(match.id) || Bet.new(:user => current_user, :match => match)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def verify_permission_for_id
    unless current_user.id == params[:id].to_i
      redirect_to users_path, notice: "You don't have the permission to edit other user's data."
    end
    
  end
end
