class BetsController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :update_matchday]
  
  # GET /bets
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  def show
    @bet = Bet.find(params[:id])
  end
  
  
  def update_matchday
    @bets = []
    params[:bet_for_match].each do |match_id, bet_attributes|
      bet = current_user.bets.find_by_match_id(match_id) || current_user.bets.build
      bet.update_attributes(bet_attributes)
      @bets << bet
    end
    
    @matchday = Matchday.find(params[:matchday_id])
    if @bets.any?{|bet| bet.errors.any?}
      render "matchdays/show"
    else 
      redirect_to @matchday, notice: 'Your bets were successfully updated.'
    end
  end


  #################################
  #         ADMINS ONLY           #
  #################################

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  def create
    @bet = Bet.new(params[:bet])
    
    if @bet.save
      redirect_to @bet, notice: 'Bet was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /bets/1
  def update
    @bet = Bet.find(params[:id])
    
    if @bet.update_attributes(params[:bet])
      redirect_to @bet, notice: 'Bet was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /bets/1
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy
    redirect_to bets_url
  end

end
