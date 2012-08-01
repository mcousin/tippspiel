require 'spec_helper'

describe Match do
  pending "add some examples to (or delete) #{__FILE__}"
  
  it "should show the competing teams" do
    match = Match.new(:team_a => "Team A", :team_b => "Team B")
    match.to_s.should == "Team A vs Team B"  
  end
end
