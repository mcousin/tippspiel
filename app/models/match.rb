class Match < ActiveRecord::Base
  attr_accessible :match_date, :score_a, :score_b, :team_a, :team_b, :bets

  has_many :bets
  
  def to_s
    "#{team_a} vs #{team_b} scored #{score_a}:#{score_b} on #{match_date}"    
  end
end
