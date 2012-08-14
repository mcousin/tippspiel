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
  
  # returns a hash that assigns ranks to users 
  # (users with equal points getting equal ranks)    
  def self.get_ranking
    ranking = {}
    
    # sort users by points
    users = User.all.sort {|a,b| b.points <=> a.points}
    
    # assign ranks
    users.each_with_index do |user, index|
      ranking[user] = index + 1
      if index > 0 && user.points == users[index - 1].points
        ranking[user] = ranking[users[index - 1]]
      end
    end
    
    ranking
  end
    
end
