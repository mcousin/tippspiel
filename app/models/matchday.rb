class Matchday < ActiveRecord::Base
  attr_accessible :matches, :match_id
  
  has_many :matches

  def to_s
    "Matchday #{id}"
  end
end
