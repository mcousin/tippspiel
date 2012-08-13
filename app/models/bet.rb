class Bet < ActiveRecord::Base
  attr_accessible :match_id, :score_a, :score_b, :user_id, :match, :user

  validates :score_a, numericality: { only_integer: true }, allow_nil: true
  validates :score_b, numericality: { only_integer: true }, allow_nil: true
  validates_presence_of :match
  validates_presence_of :user
  
  belongs_to :user
  belongs_to :match

  def scores_string
    [score_a, score_b].map{|score| score ? score.to_s : "-"}.join(":")
  end

  def points
    case result
    when :incomplete, :incorrect
      0
    when :correct_result
      3
    when :correct_goal_difference
      2
    when :correct_tendency
      1
    end
  end

  def result
    if not (match.score_a && match.score_b && score_a && score_b)
      :incomplete
    elsif [match.score_a, match.score_b] == [score_a, score_b]
      :correct_result
    elsif match.score_a - match.score_b == score_a - score_b
      :correct_goal_difference
    elsif (match.score_a <=> match.score_b) == (score_a <=> score_b)
      :correct_tendency
    else
      :incorrect
    end
  end
  
end
