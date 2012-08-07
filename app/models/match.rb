class Match < ActiveRecord::Base
  attr_accessible :match_date, :score_a, :score_b, :team_a, :team_b, :bets, :matchday, :matchday_id

  belongs_to :matchday
  has_many :bets
  
  default_scope order("match_date ASC")
  
  def to_s
    "#{team_a} vs #{team_b}"    
  end

  def started?
    DateTime.now > match_date
  end

  def scores_string
    [score_a, score_b].map{|score| score ? score.to_s : "-"}.join(":")
  end
  
  # first match that is not started (or last one, if all are started)
  def self.next
    self.all.find{|match| not match.started?} || self.last
  end
  
end
