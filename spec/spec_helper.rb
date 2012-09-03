# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

def populate_database
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

end