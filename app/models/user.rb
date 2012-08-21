class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  validates :email, presence: true,
                    uniqueness: true
  validates :name, presence: true

  has_secure_password
  has_many :bets, dependent: :destroy
  
  def total_points
    self.bets.sum { |bet| bet.points }
  end
  
  def matchday_points(matchday)
    matchday_bets = self.bets.select{|bet| bet.match && bet.match.matchday == matchday}
    matchday_bets.sum { |bet| bet.points } 
  end
  
  def admin?
    self.role == 1
  end
  
  # gets an array of users and returns a hash that maps 
  # them onto ranks
  # (users with equal points getting equal ranks)    
  #
  # by assigning a matchday to the :matchday option, the ranking can
  # be restricted to a matchday
  def self.ranking(options = {})
    users = User.all  
    ranking = {}
    points = Hash[*users.collect { |user| [user, options[:matchday] ? user.matchday_points(options[:matchday]) 
                                                                   : user.total_points]}.flatten]
    
    sorted_users = users.sort {|a,b| points[b] <=> points[a]}
    sorted_users.each_with_index do |user, index|
      ranking[user] = index + 1
      if index > 0 && points[user] == points[sorted_users[index - 1]]
        ranking[user] = ranking[sorted_users[index - 1]]
      end
    end
    
    ranking
  end
  
  # returns the fragment of ranking consisting of all users
  # that have rank within [rank of self]±radius
  def ranking_fragment(radius)
    ranking = User.ranking
    ranking.select do |user, rank|
      (rank - ranking[self]).abs <= radius
    end
  end
    
end
