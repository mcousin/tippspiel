require 'spec_helper'

describe Match do

  context "associations" do
    it { should belong_to(:matchday) }
    it { should have_many(:bets).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:team_a) }
    it { should validate_presence_of(:team_b) }
    it { should validate_presence_of(:match_date) }
    it { should validate_presence_of(:matchday)}
    it { should_not validate_presence_of(:score_a) }
    it { should_not validate_presence_of(:score_b) }
    it { should validate_numericality_of(:score_a).only_integer }
    it { should validate_numericality_of(:score_b).only_integer }

    it "should not be valid if it has ended before it has started" do
      FactoryGirl.build(:match, match_date: 1.day.from_now, has_ended: true).should_not be_valid
    end
  end


  it "has_ended should default to false" do
    Match.new.has_ended.should be_false
  end

  it "should have a to_s method show the competing teams" do
    match = FactoryGirl.build(:match)
    match.to_s.should == "#{match.team_a} vs #{match.team_b}"
  end

  it "should have a CSV import method" do
    csv_string = File.read(Rails.root.join('spec/test.csv'))
    objects = Match.build_from_csv(csv_string, :col_sep => ";", :row_sep => "\n")

    objects.count.should eq 54
    objects.each { |object| object.should be_a(Match) }
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

    it "should return nil in case there is no future match" do
      match1 = FactoryGirl.create(:match, :match_date => 2.days.ago)
      Match.next.should be_nil
    end

    it "should return nil in case no matches exist" do
      Match.next.should be_nil
    end

  end

end
