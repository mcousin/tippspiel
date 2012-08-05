class Matchday < ActiveRecord::Base
  attr_accessible :matches, :match_id, :description
  
  has_many :matches
end
