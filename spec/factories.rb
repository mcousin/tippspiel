FactoryGirl.define do


  factory :matchday do
    description  "Matchday 1"
  end

  factory :match do
    match_date  DateTime.now
    team_a      "BVB"
    team_b      "S04"
    association :matchday
  end

end