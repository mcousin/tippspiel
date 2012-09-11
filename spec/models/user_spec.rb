require 'spec_helper'

describe User do

  context "associations" do
    it { should have_many(:bets).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  context "authentication" do
    let(:user) { FactoryGirl.build(:user) }
    before { user.password = "correct password" }
    specify { user.authenticate("wrong password").should be_false }
    specify { user.authenticate("correct password").should eq user }
  end

  context "method admin?" do
    specify { FactoryGirl.build(:user, role: 1).should be_admin }
    specify { FactoryGirl.build(:user, role: 0).should_not be_admin }
  end

  context "find_or_build_bet_for_match" do

    let(:user) { FactoryGirl.create(:user) }
    let(:match) { FactoryGirl.create(:match) }

    context "for a match with a bet" do
      before { @bet = FactoryGirl.create(:bet, match: match, user: user) }
      subject { user.find_or_build_bet_for_match(match) }
      it { should eq(@bet) }
    end

    context "for a match without a bet" do
      subject { user.find_or_build_bet_for_match(match) }
      it { should be_a_new Bet }
      its(:match) { should eq(match) }
    end

  end

  context "find_or_build_bet_for_matchday" do
    let(:user) { FactoryGirl.create(:user) }
    let(:match) { FactoryGirl.create(:match) }
    after { user.find_or_build_bets_for_matchday(match.matchday) }
    specify { User.any_instance.expects(:find_or_build_bet_for_match).with(match) }
  end



  context "method total_points" do

    subject { FactoryGirl.create(:user) }

    context "no bets exist" do
      its(:total_points) { should eq 0 }
    end

    context "total points of all bets, if any" do
      before { 2.times { FactoryGirl.create(:bet, user: subject) } }
      before { Bet.any_instance.stubs(:points).returns(1) }
      its(:total_points) { should eq 2 }
    end

    context "total points as of a given matchday" do
      before { @matchday1 = FactoryGirl.create(:matchday) }
      before { @matchday2 = FactoryGirl.create(:matchday) }
      before { @matchday3 = FactoryGirl.create(:matchday) }
      before { @matchday4 = FactoryGirl.create(:matchday) }
      before { subject.stubs(:matchday_points).returns(1) }
      before { Matchday.stubs(:all_complete_matchdays_before).with(@matchday1.start).returns([@matchday2, @matchday3]) }

      specify { subject.total_points(as_of_matchday: @matchday1).should eq 3 }
    end

  end

  context "method matchday_points" do

    subject { FactoryGirl.create(:user) }

    context "should be 0 if argument is nil" do
      specify { subject.matchday_points(nil).should eq 0 }
    end

    context "should be the sum of the points of all bets of matches belonging to the given matchday" do
      let(:matches) { 3.times.map { FactoryGirl.create(:match) } }
      before { matches.third.update_attributes(matchday: matches.second.matchday) }
      before { matches.each {|match| FactoryGirl.create(:bet, user: subject, match: match)} }
      before { Bet.any_instance.stubs(:points).returns(1) }

      specify { subject.matchday_points(matches.first.matchday).should eq 1 }
      specify { subject.matchday_points(matches.second.matchday).should eq 2 }
      specify { subject.matchday_points(matches.third.matchday).should eq 2 }
    end

  end
end
