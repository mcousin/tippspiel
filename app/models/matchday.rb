class Matchday < ActiveRecord::Base
  attr_accessible :matches, :description
  
  has_many :matches

  validates :description, presence: true
  
  def start
    self.matches.min{|match| match.match_date}
  end
  
  def self.current
    Match.next.matchday
  end
  
end
