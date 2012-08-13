class Matchday < ActiveRecord::Base
  attr_accessible :matches, :description
  
  has_many :matches

  validates :description, presence: true
  
  def start
      self.matches.min{|match| match.match_date}
  end
  
  def self.current    
    if Match.any?
      Match.next.matchday
    else
      Matchday.last
    end      
  end
  
end
