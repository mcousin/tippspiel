class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  validates :email, presence: true,
                    uniqueness: true
  validates :name, presence: true

  has_secure_password
  has_many :bets, dependent: :destroy
  
  def points
    self.bets.sum { |bet| bet.points }
  end
  
  def admin?
    self.role == 1
  end
  
  # gets an array of users and returns a hash that maps 
  # them onto ranks
  # (users with equal points getting equal ranks)    
  def self.full_ranking
    ranking = {}
    sorted_users = User.all.sort {|a,b| b.points <=> a.points}
    sorted_users.each_with_index do |user, index|
      ranking[user] = index + 1
      if index > 0 && user.points == sorted_users[index - 1].points
        ranking[user] = ranking[sorted_users[index - 1]]
      end
    end
    
    ranking
  end
  
  # returns the fragment of full_ranking consisting of all users
  # that have rank within [rank of self]±radius
  def ranking_fragment(radius)
    ranking = User.full_ranking
    ranking.select do |user, rank|
      (rank - ranking[self]).abs <= radius
    end
  end    
end
