class BetsController < ApplicationController

  # GET matchdays/:matchday_id/bets
  def index
    @matchdays = Matchday.all
    @matchday = Matchday.find(params[:matchday_id])
    @bets = current_user.find_or_build_bets_for_matchday(@matchday)
    @ranking = Ranking.new(User.all, :matchday => @matchday)
  end

  # PUT matchdays/:matchday_id/bets
  def update
    @bets = (params[:bets] || {}).map do |match_id, bet_attributes|
      bet = current_user.find_or_build_bet_for_match(Match.find_by_id(match_id))
      bet.update_attributes(bet_attributes)
      bet
    end

    @matchday = Matchday.find(params[:matchday_id])
    if @bets.any?{|bet| bet.errors.any?}
      render action: "index"
    else
      redirect_to :back, notice: 'Your bets were successfully updated.'
    end
  end

end
