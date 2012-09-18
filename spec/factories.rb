FactoryGirl.define do


  factory :matchday do
    description  "Matchday 1"
  end

  factory :match do
    matchday
    home_team
    away_team
    match_date  1.day.from_now
    team_a      "BVB"
    team_b      "S04"
  end

  factory :user do
    name        { FactoryGirl.generate(:user_name) }
    email       { FactoryGirl.generate(:user_email) }

    after(:build) do |user|
      user.password = "password"
    end
  end

  factory :bet do
    user
    match
  end


  factory :team, :aliases => [:home_team, :away_team] do
    name        { FactoryGirl.generate(:team_name) }
  end

  sequence :user_email do |n|
    "email#{n}@foo.com"
  end

  sequence :user_name do |n|
    "User #{n}"
  end

  sequence :team_name do |n|
    "Team #{n}"
  end


end