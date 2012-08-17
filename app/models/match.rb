require 'CSV'

class Match < ActiveRecord::Base
  attr_accessible :match_date, :score_a, :score_b, :team_a, :team_b, :bets, :matchday, :matchday_id

  belongs_to :matchday
  has_many :bets, dependent: :destroy
  
  validates :team_a, presence: true
  validates :team_b, presence: true
  validates :score_a, numericality: { only_integer: true }, allow_nil: true
  validates :score_b, numericality: { only_integer: true }, allow_nil: true
  validates :match_date, presence: true
    
  validates_presence_of :matchday

  
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
  
  def self.build_from_csv(csv_string, options = {})    
    csv = CSV.new(csv_string, options)
  
    matches = []    
    csv.each do |row|
      attributes = {match_date: row.first, team_a: row.second, team_b: row.third}
      matches << Match.new(attributes)
    end
    matches
  end
  
end
