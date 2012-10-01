

class Ranking

  include Enumerable

  def initialize(users, options = {})
    @users = users
    generate(options)
  end

  def each
    ranking_elements.each{|element| yield(element)}
  end

  def rank(user)
    @ranking[user] if @ranking
  end

  def ranks
    @ranking.values
  end

  def generate(options = {})
    @ranking = {}
    points_method = options[:matchday] ? [:matchday_points, options[:matchday]] : [:total_points]
    points = Hash[*@users.collect { |user| [user, user.send(*points_method)]}.flatten]

    sorted_users = @users.sort {|a,b| points[b] <=> points[a]}
    sorted_users.each_with_index do |user, index|
      @ranking[user] = index + 1
      if index > 0 && points[user] == points[sorted_users[index - 1]]
        @ranking[user] = @ranking[sorted_users[index - 1]]
      end
    end
  end

  def fragment_for(user, options = {})
    radius = options[:radius] || 1

    selected_ranks = [1, ranks.max, rank(user)]
    selected_ranks += @ranking.values.uniq.select{|r| r < rank(user)}.sort.last(radius)
    selected_ranks += @ranking.values.uniq.select{|r| r > rank(user)}.sort.first(radius)

    ranking_elements.select { |element| selected_ranks.include?(element.rank) }
  end


  private

    def ranking_elements
      @ranking_elements ||= @ranking.sort_by {|user, rank| rank}.map {|pair| RankingElement.new(pair.first, pair.second)}
    end

end


class RankingElement
  attr_reader :user, :rank

  def initialize(user, rank)
    @user = user
    @rank = rank
  end
end
