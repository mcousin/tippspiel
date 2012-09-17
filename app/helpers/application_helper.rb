module ApplicationHelper

  def award_text(award)
    case award
    when :leader
      { small: "You're", large: "N1!" }
    when :last
      { small: "Oh, you're", large: "LAST!" }
    when :matchday_leader
      { small: "Todays", large: "BEST!" }
    when :none
      { small: "No award", large: "so far!" }
    when :none
      { small: "unknown", large: "award" }
    end
  end

  def award_class(award)
    case award
    when :leader
      "badge-number-one"
    when :last
      "badge-number-last"
    when :matchday_leader
      "badge-match-day-winner"
    when :none
      "badge-none"
    else
      ""
    end
  end

end
