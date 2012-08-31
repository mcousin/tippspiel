require 'spec_helper'

describe Match do

  it "should show the competing teams" do
    match = FactoryGirl.build(:match)
    match.to_s.should == "#{match.team_a} vs #{match.team_b}"
  end

  it "should have a CSV import method" do
    csv_string = File.read(Rails.root.join('spec/test.csv'))
    objects = Match.build_from_csv(csv_string, :col_sep => ";", :row_sep => "\n")

    objects.count.should eq 54
    objects.each do |object|
      object.should be_a(Match)
    end

  end

  it "should have a factory creating a valid object" do
    FactoryGirl.build(:match).should be_valid
  end

  it "should have a method checking whether the match has started" do
    FactoryGirl.build(:match, :match_date => 1.day.ago).should be_started
    FactoryGirl.build(:match, :match_date => 1.day.from_now).should_not be_started
  end

  context "Match.next" do

    it "should return the upcoming future match in case there is one" do
      match1 = FactoryGirl.create(:match, :match_date => 2.days.ago)
      match2 = FactoryGirl.create(:match, :match_date => 1.day.from_now)
      match3 = FactoryGirl.create(:match, :match_date => 2.days.from_now)
      Match.next.should eq match2
    end

    it "should return the latest match in case there is no future match" do
      match1 = FactoryGirl.create(:match, :match_date => 2.days.ago)
      match2 = FactoryGirl.create(:match, :match_date => 1.day.ago)
      Match.next.should eq match2
    end

    it "should return nil in case no matches exist" do
      Match.next.should be_nil
    end

  end

end
