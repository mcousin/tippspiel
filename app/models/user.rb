class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  validates :email, presence: true,
                    uniqueness: true
  validates :name, presence: true

  has_secure_password
  has_many :bets, dependent: :destroy

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def find_or_build_bets_for_matchday(matchday)
    matchday.matches.map { |match| find_or_build_bet_for_match(match) }
  end

  def find_or_build_bet_for_match(match)
    bets.find_by_match_id(match.id) || bets.build(match: match)
  end

  def total_points(options = {})
    if options[:as_of_matchday]
      this_matchday = options[:as_of_matchday]
      earlier_matchdays = Matchday.select{|matchday| matchday.complete? && matchday.start < this_matchday.start}
      (earlier_matchdays << this_matchday).sum {|matchday| matchday_points(matchday)}
    else
      self.bets.sum { |bet| bet.points }
    end
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
    selected_ranks += ranking.values.uniq.select{|r| r < ranking[self]}.sort.last(radius)
    selected_ranks += ranking.values.uniq.select{|r| r > ranking[self]}.sort.first(radius)

    ranking.select do |user, rank|
      selected_ranks.include?(rank)
    end
  end

  def awards
    awards = []

    ranking = User.ranking
    case ranking[self]
    when 1
      awards << ["badge-number-one", "You're", "N1!"]
    when ranking.values.max
      awards << ["badge-number-last", "Oh, you're", "LAST!"]
    end

    first_incomplete_matchday = Matchday.first_incomplete
    if first_incomplete_matchday && first_incomplete_matchday.started?
      matchday = first_incomplete_matchday
    else
      matchday = Matchday.last_complete
    end

    if matchday
      ranking = User.ranking(:matchday => matchday)
      case ranking[self]
      when 1
        awards << ["badge-match-day-winner", "Todays", "BEST!"]
      end
    end

    if awards.empty?
      awards << ["badge-none", "No award", "so far!"]
    end
    awards

  end
end
