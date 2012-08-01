class Matchday < ActiveRecord::Base
  attr_accessible :matches
  
  has_many :matches
end
