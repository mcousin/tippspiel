class BetsController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :update_matchday]
  
  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @bet = Bet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bet }
    end
  end
  
  def update_matchday
    @bets = []
    params[:bet_for_match].each do |match_id, bet_attributes|
      bet = current_user.bets.find_by_match_id(match_id) || current_user.bets.create
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
  # GET /bets/new.json
  def new
    @bet = Bet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bet }
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(params[:bet])

    respond_to do |format|
      if @bet.save
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.json
  def update
    @bet = Bet.find(params[:id])

    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy

    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :no_content }
    end
  end

end
