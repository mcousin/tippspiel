class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  before_create { generate_token(:auth_token) }
  has_many :bets, dependent: :destroy
  has_secure_password


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
      matchdays = Matchday.all_complete_matchdays_before(this_matchday.start) + [this_matchday]
      matchdays.sum { |matchday| matchday_points(matchday) }
    else
      self.bets.sum { |bet| bet.points }
    end
  end

  def matchday_points(matchday)
    matchday_bets = self.bets.select{|bet| bet.matchday == matchday}
    matchday_bets.sum { |bet| bet.points }
  end

  def admin?
    self.role == 1
  end


  def awards
    awards = []

    ranking = Ranking.new(User.all)
    case ranking.rank(self)
    when 1
      awards << ["badge-number-one", "You're", "N1!"]
    when ranking.map{|element| element.rank}.max
      awards << ["badge-number-last", "Oh, you're", "LAST!"]
    end

    first_incomplete_matchday = Matchday.first_incomplete
    if first_incomplete_matchday && first_incomplete_matchday.has_started?
      matchday = first_incomplete_matchday
    else
      matchday = Matchday.last_complete
    end

    if matchday
      ranking = Ranking.new(User.all, :matchday => matchday)
      case ranking.rank(self)
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
