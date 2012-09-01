require 'spec_helper'

describe User do

  it "should have a factory creating a valid object" do
    FactoryGirl.build(:user).should be_valid
  end

  it "should authenticate a user correctly" do
    user = FactoryGirl.build(:user)
    user.password = "correct password"
    user.authenticate("wrong password").should be_false
    user.authenticate("correct password").should eq user
  end

  it "should have a function that checks whether the user is admin" do
    FactoryGirl.build(:user, role: 1).should be_admin
    FactoryGirl.build(:user, role: 0).should_not be_admin
  end



  context "total points" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should be the sum of the points of all bets" do
      bet1 = FactoryGirl.create(:bet, user: @user)
      bet2 = FactoryGirl.create(:bet, user: @user)
      another_user = FactoryGirl.create(:user)
      bet_of_another_user = FactoryGirl.create(:bet)
      Bet.any_instance.expects(:points).twice.returns(1)
      @user.total_points.should eq 2
    end

    it "should be 0 if no bets exist" do
      FactoryGirl.build(:user).total_points.should eq 0
    end



    context "up to a given matchday" do
      it "should be sum of all points of complete matchdays up to the given matchday" do

        matches = [FactoryGirl.create(:match, match_date: 3.days.ago, has_ended: true), # yields a complete matchday in the past
                   FactoryGirl.create(:match, match_date: 2.day.ago, has_ended: false), # yields an incomplete matchday in the past
                   FactoryGirl.create(:match, match_date: 1.day.ago),                   # match for this matchday
                   FactoryGirl.create(:match, match_date: 1.day.from_now)             ] # yields a future matchday

        matchday = matches.third.matchday

        Bet.any_instance.stubs(:no_changes_after_match_start)     # turn off validation to allow creating bets for matches in the past
        bets = matches.map{ |match| FactoryGirl.create(:bet, match: match, user: @user) }

        Bet.any_instance.expects(:points).twice.returns(1)
        @user.total_points(as_of_matchday: matchday).should eq 2         # only first and third match should be taken into account

      end

      it "should be 0 if no matchday exists" do
        @user.total_points(as_of_matchday: nil).should eq 0
      end
    end

  end

  context "matchday points" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end


    it "should be the sum of the points of all bets of matches belonging to the given matchday" do
      matchday1 = FactoryGirl.create(:matchday)
      matchday2 = FactoryGirl.create(:matchday)

      matches = [FactoryGirl.create(:match, matchday: matchday1),
                 FactoryGirl.create(:match, matchday: matchday2),
                 FactoryGirl.create(:match, matchday: matchday2)]

      bets = matches.map{ |match| FactoryGirl.create(:bet, match: match, user: @user) }

      Bet.any_instance.expects(:points).twice.returns(1)
      @user.matchday_points(matchday2).should eq 2
    end

    it "should be 0 if no matchday exists" do
      @user.matchday_points(nil).should eq 0
    end

  end




  it "should compute ranks correctly" do
    user1 = mock("user1")
    user2 = mock("user2")
    user3 = mock("user3")

    User.stubs(:all).returns([user1, user2, user3])
    user1.stubs(:total_points).returns(2)
    user2.stubs(:total_points).returns(4)
    user3.stubs(:total_points).returns(4)

    ranking = User.ranking
    ranking[user1].should eq(3)
    ranking[user2].should eq(1)
    ranking[user3].should eq(1)

  end
end
