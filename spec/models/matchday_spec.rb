require 'spec_helper'

describe Matchday do

  it "should have a factory creating a valid object" do
    FactoryGirl.build(:matchday).should be_valid
  end

  context "start" do

    it "should return the beginning of the first of its matches" do
      matchday = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday, match_date: 1.day.ago)
      match2 = FactoryGirl.create(:match, matchday: matchday, match_date: 1.day.from_now)
      match3 = FactoryGirl.create(:match, matchday: matchday, match_date: 2.days.from_now)

      matchday.start.should eq match1.match_date
    end

    it "should return nil if it has no matches" do
      FactoryGirl.create(:matchday).start.should be_nil
    end

    it "should compare matchdays by start" do
      early_matchday = FactoryGirl.build(:matchday)
      early_matchday.stubs(:start).returns(2.days.ago)

      late_matchday = FactoryGirl.build(:matchday)
      late_matchday.stubs(:start).returns(1.day.ago)

      (early_matchday <=> late_matchday).should eq(-1)
      [late_matchday, early_matchday].sort.should eq([early_matchday, late_matchday])
    end

    it "should regard a match as started? once its start lies in the past" do
      started_matchday = FactoryGirl.build(:matchday)
      started_matchday.stubs(:start).returns(1.day.ago)
      started_matchday.should be_started

      future_matchday = FactoryGirl.build(:matchday)
      future_matchday.stubs(:start).returns(1.day.from_now)
      future_matchday.should_not be_started
    end

  end

  context "complete?" do

    it "should return true if all of its matches have ended" do
      matchday = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday, match_date: 1.day.ago, has_ended: true)
      match2 = FactoryGirl.create(:match, matchday: matchday, match_date: 2.days.ago, has_ended: true)

      matchday.should be_complete
    end

    it "should return false if it has a match that has not ended yet" do
      matchday = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday, match_date: 1.day.ago, has_ended: true)
      match2 = FactoryGirl.create(:match, matchday: matchday, match_date: 1.day.from_now, has_ended: false)

      matchday.should_not be_complete
    end

    it "should return true if it has no matches" do
      matchday = FactoryGirl.create(:matchday).should be_complete
    end

  end

  context "Matchday.next_to_bet" do

    it "should return the matchday that contains the next match" do
      matchday1 = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday1, match_date: 1.day.ago)

      matchday2 = FactoryGirl.create(:matchday)
      match2 = FactoryGirl.create(:match, matchday: matchday2, match_date: 1.day.from_now)

      matchday3 = FactoryGirl.create(:matchday)
      match3 = FactoryGirl.create(:match, matchday: matchday3, match_date: 2.days.from_now)

      Matchday.next_to_bet.should eq matchday2
    end

    it "should return nil if all matches have started" do
      matchday1 = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday1, match_date: 1.day.ago)

      Matchday.next_to_bet.should be_nil
    end

  end




  context "Matchday.last_complete" do

    it "should return the most recent matchday that is complete" do
      matchday1 = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday1, match_date: 2.days.ago, has_ended: true)

      matchday2 = FactoryGirl.create(:matchday)
      match2 = FactoryGirl.create(:match, matchday: matchday2, match_date: 1.day.ago, has_ended: false)

      matchday3 = FactoryGirl.create(:matchday)
      match3 = FactoryGirl.create(:match, matchday: matchday3, match_date: 3.days.ago, has_ended: true)

      Matchday.last_complete.should eq matchday1
    end

    it "should return nil if there is no complete matchday" do
      Matchday.last_complete.should be_nil
    end

  end

  context "Matchday.first_incomplete" do

    it "should return the most recent matchday that is incomplete" do
      matchday1 = FactoryGirl.create(:matchday)
      match1 = FactoryGirl.create(:match, matchday: matchday1, match_date: 3.days.ago, has_ended: true)

      matchday2 = FactoryGirl.create(:matchday)
      match2 = FactoryGirl.create(:match, matchday: matchday2, match_date: 2.days.ago, has_ended: false)

      matchday3 = FactoryGirl.create(:matchday)
      match3 = FactoryGirl.create(:match, matchday: matchday3, match_date: 1.day.ago, has_ended: true)

      Matchday.first_incomplete.should eq matchday2
    end

    it "should return nil if there is no complete matchday" do
      Matchday.first_incomplete.should be_nil
    end

  end

  context "Matchday.current" do

    let(:mocked_matchday) { mock("matchday") }

    it "should return the matchday that next to bet, if any" do
      Matchday.expects(:next_to_bet).returns(mocked_matchday)
      Matchday.current.should eq mocked_matchday
    end

    it "should return the first incomplete matchday if there are no matches to bet" do
      Matchday.expects(:next_to_bet).returns(nil)
      Matchday.expects(:first_incomplete).returns(mocked_matchday)
      Matchday.current.should eq mocked_matchday
    end

    it "should return the last complete matchday if there are no matches to bet and no incomplete matchdays" do
      Matchday.expects(:next_to_bet).returns(nil)
      Matchday.expects(:first_incomplete).returns(nil)
      Matchday.expects(:last_complete).returns(mocked_matchday)
      Matchday.current.should eq mocked_matchday
    end

    it "should return nil if no matchdays exist" do
      Matchday.current.should be_nil
    end

  end







end
