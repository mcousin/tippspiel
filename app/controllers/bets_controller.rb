class BetsController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :update_matchday]
  
  # GET matchdays/:matchday_id/bets
  def index
    raise "NOT YET IMPLEMENTED!"
  end
  
  # GET matchdays/:matchday_id/bets/edit
  def edit
    @matchday = Matchday.find(params[:matchday_id])
    @bets = @matchday.matches.map do |match|
      current_user.bets.find_by_match_id(match.id) || current_user.bets.build(match: match)
    end
  end
  

  # PUT matchdays/:matchday_id/bets
  def update
    raise
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

end
