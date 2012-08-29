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
  #
  # can be restricted further using the same options as User.ranking
  def ranking_fragment(radius, options = {})
    ranking = User.ranking(options)

    selected_ranks = [ranking.values.min, ranking.values.max, ranking[self]]
    selected_ranks += ranking.values.select{|r| r < ranking[self]}.sort.last(radius)
    selected_ranks += ranking.values.select{|r| r > ranking[self]}.sort.first(radius)
    
    ranking.select do |user, rank|
      selected_ranks.include?(rank)
    end
  end
  
  def my_awards
    awards = Array.new
    
    ranking = User.ranking.sort_by {|user, rank| rank}
    ranking.each  do |user, rank|
      if user.id == self.id
        case rank
        when 1
          awards << ["badge-number-one", "You're", "N1!"]
        when ranking.sort.last[1]
          awards << ["badge-number-last", "Oh, you're", "LAST!"]
        end
      end
    end
    
    ranking = User.ranking(:matchday => Matchday.find(1)).sort_by {|user, rank| rank}
    ranking.each  do |user, rank|
      if user.id == self.id
        case rank
        when 1
          awards << ["badge-match-day-winner", "Todays", "BEST!"]
        end
      end
    end    
    awards
  end
end
