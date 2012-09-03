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


        matches.each do |match|
          bet = FactoryGirl.build(:bet, match: match, user: @user)
          bet.save(validate: false) # turn off validation to allow creating bets for matches in the past
        end

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



  context "ranking computation" do

    before(:each) do
      @users = 10.times.map{|n| FactoryGirl.build(:user)}
      User.stubs(:all).returns(@users)

      points = [10,8,8,7,6,5,4,3,2,2]
      @users.each_index do |n|
        @users[n].stubs(:total_points).returns(points[n])
      end
    end

    context "for a full ranking" do
      it "should be correct" do
        ranking = User.ranking
        ranking[@users[0]].should eq(1)
        ranking[@users[1]].should eq(2)
        ranking[@users[2]].should eq(2)
        ranking[@users[3]].should eq(4)
        ranking[@users[4]].should eq(5)
        ranking[@users[5]].should eq(6)
        ranking[@users[6]].should eq(7)
        ranking[@users[7]].should eq(8)
        ranking[@users[8]].should eq(9)
        ranking[@users[9]].should eq(9)
      end

      it "should be correct when restricting to one matchday" do
        mocked_matchday = mock("matchday")
        points = [10,8,8,7,6,5,4,3,2,2]
        @users.each_index do |n|
          @users[n].stubs(:total_points).returns(100)
          @users[n].stubs(:matchday_points).with(mocked_matchday).returns(points[n])
        end
        ranking = User.ranking(matchday: mocked_matchday)
        ranking[@users[0]].should eq(1)
        ranking[@users[1]].should eq(2)
        ranking[@users[2]].should eq(2)
        ranking[@users[3]].should eq(4)
        ranking[@users[4]].should eq(5)
        ranking[@users[5]].should eq(6)
        ranking[@users[6]].should eq(7)
        ranking[@users[7]].should eq(8)
        ranking[@users[8]].should eq(9)
        ranking[@users[9]].should eq(9)
      end
    end


    context "for a ranking fragment" do
      it "should be correct for a user from the middle of the ranking" do
        ranking = @users[0].ranking_fragment(2)
        ranking.values.sort.should eq [1,2,2,4,9,9]
      end

      it "should be correct for a user from the top of the ranking" do
        ranking = @users[5].ranking_fragment(1)
        ranking.values.sort.should eq [1,5,6,7,9,9]
      end

      it "should be correct for a user from the bottom of the ranking" do
        ranking = @users[7].ranking_fragment(1)
        ranking.values.sort.should eq [1,7,8,9,9]
      end

    end





  end
end
