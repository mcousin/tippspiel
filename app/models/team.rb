class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :home_matches, class_name: Match, foreign_key: :home_team_id
  has_many :away_matches, class_name: Match, foreign_key: :away_team_id
end
