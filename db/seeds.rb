# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


# matchday with all matches in the past
matchday1 = FactoryGirl.create(:matchday, description: "Matchday 1")
3.times do
  FactoryGirl.create(:match, score_a: 2, score_b: 1, matchday: matchday1, match_date: 1.week.ago, has_ended: true)
end

# matchday with some matches in the past and some in the future and some running matches
matchday2 = FactoryGirl.create(:matchday, description: "Matchday 2")
1.times do
  FactoryGirl.create(:match, score_a: 2, score_b: 1, matchday: matchday2, match_date: 1.day.ago, has_ended: true)
end
1.times do
  FactoryGirl.create(:match, score_a: 2, score_b: 1, matchday: matchday2, match_date: 1.hour.ago, has_ended: false)
end
1.times do
  FactoryGirl.create(:match, matchday: matchday2, match_date: 1.day.from_now, has_ended: false)
end

# future matchday
matchday3 = FactoryGirl.create(:matchday, description: "Matchday 3")
3.times do
  FactoryGirl.create(:match, matchday: matchday3, match_date: 1.week.from_now, has_ended: false)
end

# create some users and add bets for Matchdays 1 and 2, the n-th user always betting n-0
3.times do |n|
  user = FactoryGirl.create(:user)
  [matchday1, matchday2].each do |matchday|
    matchday.matches.each do |match|
      bet = FactoryGirl.build(:bet, user: user, match: match, score_a: n, score_b: 0)
      bet.save(validate: false)
    end
  end
end

