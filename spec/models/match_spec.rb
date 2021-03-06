require 'spec_helper'

describe Match do

  context "associations" do
    it { should belong_to(:matchday) }
    it { should have_many(:bets).dependent(:destroy) }
    it { should belong_to(:home_team).class_name(Team) }
    it { should belong_to(:away_team).class_name(Team) }
  end

  context "validations" do
    it { should validate_presence_of(:home_team) }
    it { should validate_presence_of(:away_team) }
    it { should validate_presence_of(:match_date) }
    it { should validate_presence_of(:matchday)}
    it { should_not validate_presence_of(:score_a) }
    it { should_not validate_presence_of(:score_b) }
    it { should validate_numericality_of(:score_a).only_integer }
    it { should validate_numericality_of(:score_b).only_integer }

    context "a match that has ended before it has started" do
      subject { FactoryGirl.build(:match, match_date: 1.day.from_now, has_ended: true) }
      it { should_not be_valid }
    end
  end

  context "defaults" do
    subject { Match.new}
    it { should_not have_ended }
  end

  context "method to_s" do
    let(:match) { FactoryGirl.build(:match) }
    subject { match }
    its(:to_s) { should eq "#{match.home_team.name} vs #{match.away_team.name}" }
  end

  context "CSV import" do
    pending("will be removed")
    # let(:csv) { File.read(Rails.root.join('spec/test.csv')) }
    # subject { Match.build_from_csv(csv, :col_sep => ";", :row_sep => "\n") }
    # its(:count) { should eq 54 }
    # its(:first) { should be_a(Match) }
  end

  context "method has_started?" do

    context "for a match that has started" do
      subject { FactoryGirl.build(:match, :match_date => 1.day.ago) }
      it { should have_started }
    end

    context "for a match that has not started" do
      subject { FactoryGirl.build(:match, :match_date => 1.day.from_now) }
      it { should_not have_started }
    end

  end

  context "Match.next" do

    context "in case there is no future match" do
      before { FactoryGirl.create(:match, :match_date => 2.days.ago) }
      before { @match = FactoryGirl.create(:match, :match_date => 1.day.from_now) }
      before { FactoryGirl.create(:match, :match_date => 2.days.from_now) }
      subject { Match.next }
      it { should eq @match }
    end

    context "in case there is no future match" do
      before { FactoryGirl.create(:match, :match_date => 2.days.ago) }
      subject { Match.next }
      it { should be_nil }
    end

    context "in case no matches exist" do
      subject { Match.next }
      it { should be_nil }
    end

  end

end
