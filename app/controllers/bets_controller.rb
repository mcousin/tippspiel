class BetsController < ApplicationController

  # GET matchdays/:matchday_id/bets
  def index
    @matchday = Matchday.find(params[:matchday_id])
    @bets = @matchday.matches.map do |match|
      current_user.bets.find_by_match_id(match.id) || current_user.bets.build(match: match)
    end
  end

  # PUT matchdays/:matchday_id/bets
  def update
    @bets = []
    if params[:bets]
      params[:bets].each do |match_id, bet_attributes|
        bet = current_user.bets.find_by_match_id(match_id) || current_user.bets.build(match_id: match_id)
        bet.update_attributes(bet_attributes)
        @bets << bet
      end
    end

    @matchday = Matchday.find(params[:matchday_id])
    if @bets.any?{|bet| bet.errors.any?}
      render "bets/index"
    else
      redirect_to :back, notice: 'Your bets were successfully updated.'
    end
  end

end
