require 'spec_helper'

describe Match do
  pending "add some examples to (or delete) #{__FILE__}"
  
  it "should put the match details" do
    match = Match.new(:score_a => 1, :score_b => 2, :team_a => "Team A", :team_b => "Team B")
    match.to_s.should == "Team A vs Team B scored 1:2 on "  
  end
end
