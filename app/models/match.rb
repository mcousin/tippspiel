require 'csv'

class Match < ActiveRecord::Base
  attr_accessible :match_date, :score_a, :score_b, :team_a, :team_b, :bets, :matchday, :matchday_id, :has_ended

  belongs_to :matchday
  has_many :bets, dependent: :destroy

  validates :team_a, presence: true
  validates :team_b, presence: true
  validates :score_a, numericality: { only_integer: true }, allow_nil: true
  validates :score_b, numericality: { only_integer: true }, allow_nil: true
  validates :match_date, presence: true

  validates_presence_of :matchday

  validate :match_has_not_ended_before_its_start

  default_scope order("match_date ASC")


  after_initialize :set_defaults

  def set_defaults
    self.has_ended ||= false
  end


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
    self.all.find{|match| not match.started?}
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

  def match_has_not_ended_before_its_start
    if has_ended and not started?
      errors.add(:has_ended, "can't true if match has not even started.")
    end
  end
end
