require 'spec_helper'

describe Matchday do

  context "associations" do
    it { should belong_to(:league) }
    it { should have_many(:matches).dependent(:destroy) }
  end


  context "method start" do

    subject { FactoryGirl.build(:matchday) }

    context "should have a default start if it has no matches" do
      its(:start) { should eq DateTime.new(2222)}
    end

    context "returning the beginning of the first of its matches, if any" do
      before { subject.matches = [         FactoryGirl.build(:match, match_date: 1.day.from_now),
                                  @match = FactoryGirl.build(:match, match_date: 1.day.ago),
                                           FactoryGirl.build(:match, match_date: 2.days.from_now)] }
      its(:start) { should eq @match.match_date }
    end

  end


  context "comparing matchdays" do
    let (:early_matchday) { FactoryGirl.build(:matchday) }
    let (:late_matchday) { FactoryGirl.build(:matchday) }

    before { early_matchday.stubs(:start).returns(2.days.ago) }
    before { late_matchday.stubs(:start).returns(1.day.ago) }

    specify { (early_matchday <=> late_matchday).should eq(-1) }
    specify { [late_matchday, early_matchday].sort.should eq([early_matchday, late_matchday]) }
  end

  context "method has_started?" do

    subject { FactoryGirl.build(:matchday) }

    context "for a started match" do
      before { subject.stubs(:start).returns(1.day.ago) }
      it { should have_started }
    end

    context "for a future match" do
      before { subject.stubs(:start).returns(1.day.from_now) }
      it { should_not have_started }
    end

  end

  context "method complete?" do

    subject { FactoryGirl.build(:matchday) }

    context "should return true if it has no matches" do
      it { should be_complete }
    end

    context "all of its matches have ended" do
      before { subject.matches = [FactoryGirl.build(:match, match_date: 1.day.ago, has_ended: true),
                                  FactoryGirl.build(:match, match_date: 2.days.ago, has_ended: true)] }
      it { should be_complete }
    end

    context "should return false if it has a match that has not ended yet" do
      before { subject.matches = [FactoryGirl.build(:match, match_date: 1.day.ago, has_ended: true),
                                  FactoryGirl.build(:match, match_date: 1.day.from_now, has_ended: false)] }
      it { should_not be_complete }
    end

  end

  context "Matchday.next_to_bet" do

    subject { Matchday.next_to_bet }

    context "returning the matchday that contains the next match" do
      before {          FactoryGirl.create(:match, match_date: 1.day.ago) }
      before { @match = FactoryGirl.create(:match, match_date: 1.day.from_now) }
      before {          FactoryGirl.create(:match, match_date: 2.days.from_now) }
      it { should eq @match.matchday }
    end

    context "Match.next returns nil" do
      before { Match.stubs(:next).returns(nil) }
      it { should be_nil }
    end

  end

  context "methods last_complete and first_incomplete" do

    before { @match1 = FactoryGirl.create(:match, match_date: 3.days.ago, has_ended: true) }
    before { @match2 = FactoryGirl.create(:match, match_date: 2.day.ago, has_ended: false) }
    before { @match3 = FactoryGirl.create(:match, match_date: 1.days.ago, has_ended: true) }
    before { @match4 = FactoryGirl.create(:match, match_date: 1.day.from_now, has_ended: false) }

    specify { Matchday.last_complete.should eq @match3.matchday }
    specify { Matchday.first_incomplete.should eq @match2.matchday }

    context "no complete matchday" do
      before { Matchday.any_instance.stubs(:complete?).returns(false) }
      specify { Matchday.last_complete.should be_nil }
      specify { Matchday.first_incomplete.should eq @match1.matchday }
    end

    context "no incomplete matchday" do
      before { Matchday.any_instance.stubs(:complete?).returns(true) }
      specify { Matchday.last_complete.should eq @match4.matchday }
      specify { Matchday.first_incomplete.should be_nil }
    end

  end


  context "Matchday.current" do

    subject { Matchday.current }
    let(:mocked_matchday) { mock("matchday") }

    context "should return the matchday that next to bet, if any" do
      before { Matchday.stubs(:next_to_bet).returns(mocked_matchday) }
      it { should eq mocked_matchday }
    end

    context "should return the first incomplete matchday if there are no matches to bet" do
      before { Matchday.stubs(:next_to_bet).returns(nil) }
      before { Matchday.stubs(:first_incomplete).returns(mocked_matchday) }
      it { should eq mocked_matchday }
    end

    context "should return the last complete matchday if there are no matches to bet and no incomplete matchdays" do
      before { Matchday.stubs(:next_to_bet).returns(nil) }
      before { Matchday.stubs(:first_incomplete).returns(nil) }
      before { Matchday.stubs(:last_complete).returns(mocked_matchday) }
      it { should eq mocked_matchday }
    end

    context "should return nil if no matchdays exist" do
      it { should be_nil }
    end

  end







end
