class Matchday < ActiveRecord::Base
  attr_accessible :matches, :match_id, :description
  
  has_many :matches
  
  def start
    self.matches.min{|match| match.date}
  end
  
  def self.current
    Match.next.matchday
  end
  
end
