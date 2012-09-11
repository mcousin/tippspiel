

class Ranking

  include Enumerable

  def initialize(users, options = {})
    @users = users
    update(options)
  end

  def each
    ranking_elements.each{|element| yield(element)}
  end

  def rank(user)
    @ranking[user] if @ranking
  end

  def fragment_for(user, options = {})
    radius = options[:radius] || 1
    selected_ranks = [@ranking.values.min, @ranking.values.max, rank(user)]
    selected_ranks += @ranking.values.uniq.select{|r| r < rank(user)}.sort.last(radius)
    selected_ranks += @ranking.values.uniq.select{|r| r > rank(user)}.sort.first(radius)

    ranking_elements.select do |element|
      selected_ranks.include?(element.rank)
    end
  end

  def ranking_elements
    @ranking_elements ||= @ranking.sort_by {|user, rank| rank}.map {|pair| RankingElement.new(pair.first, pair.second)}
  end

  private

  def update(options = {})
    @ranking = {}
    points = Hash[*@users.collect { |user| [user, options[:matchday] ? user.matchday_points(options[:matchday])
                                                                     : user.total_points]}.flatten]

    sorted_users = @users.sort {|a,b| points[b] <=> points[a]}
    sorted_users.each_with_index do |user, index|
      @ranking[user] = index + 1
      if index > 0 && points[user] == points[sorted_users[index - 1]]
        @ranking[user] = @ranking[sorted_users[index - 1]]
      end
    end
  end


end


class RankingElement
  attr_reader :user, :rank

  def initialize(user, rank)
    @user = user
    @rank = rank
  end
end
