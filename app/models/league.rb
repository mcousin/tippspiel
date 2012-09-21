class League < ActiveRecord::Base
  attr_accessible :description

  has_and_belongs_to_many :teams
  has_many :matchdays
  has_many :matches, through: :matchdays
  has_one :open_liga_db_league
end
