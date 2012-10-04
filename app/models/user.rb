class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role, :send_reminder

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

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
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
    awards << :leader if ranking.rank(self) == 1
    awards << :last if ranking.rank(self) == ranking.ranks.max

    matchday = Matchday.last_running || Matchday.last_complete

    if matchday
      matchday_ranking = Ranking.new(User.all, :matchday => matchday)
      awards << :matchday_leader if matchday_ranking.rank(self) == 1
    end

    awards
  end

end
