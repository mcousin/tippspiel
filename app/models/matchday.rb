class Matchday < ActiveRecord::Base
  attr_accessible :matches, :description

  has_many :matches, dependent: :destroy

  validates :description, presence: true

  def start
    self.matches.map{|match| match.match_date}.min
  end

  def started?
    start < Time.now
  end

  def <=>(other)
    start <=> other.start
  end

  def complete?
    not self.matches.any?{|match| not match.has_ended}
  end

  def self.next_to_bet
    Match.next.matchday if Match.next
  end

  def self.last_complete
    self.select{|matchday| matchday.complete?}.sort.last
  end

  def self.first_incomplete
    self.select{|matchday| not matchday.complete?}.sort.first
  end

  def self.current
    self.next_to_bet || self.first_incomplete || self.last_complete
  end

end
