require 'spec_helper'

describe Match do
  
  it "should show the competing teams" do
    match = Match.new(:team_a => "Team A", :team_b => "Team B")
    match.to_s.should == "Team A vs Team B"  
  end
  
  it "should have a CSV import method" do
    csv_string = File.read(Rails.root.join('spec/test.csv'))
    objects = Match.build_from_csv(csv_string, :col_sep => ";", :row_sep => "\n")
    
    objects.count.should eq 54
    objects.each do |object|
      object.should be_a(Match)
      object.match_date.zone.should == "CEST"
    end

  end
end
