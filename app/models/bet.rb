class Bet < ActiveRecord::Base
  attr_accessible :match_id, :score_a, :score_b, :user_id, :match
  
  belongs_to :user
  belongs_to :match
  
end
