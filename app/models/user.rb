class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  has_secure_password
  has_many :bets
  
  def points
    points = 0
    self.bets.each { |bet| points += bet.points }
    points
  end
  
end
