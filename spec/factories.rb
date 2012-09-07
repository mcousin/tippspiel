FactoryGirl.define do


  factory :matchday do
    description  "Matchday 1"
  end

  factory :match do
    matchday
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

  sequence :user_email do |n|
    "email#{n}@foo.com"
  end

  sequence :user_name do |n|
    "User #{n}"
  end


end