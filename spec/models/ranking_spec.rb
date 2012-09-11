require 'spec_helper'

describe Ranking do

  context "ranking computation" do

    let(:users) { 10.times.map{|n| FactoryGirl.build(:user)} }
    let(:points) { [10,8,8,7,6,5,4,3,2,2] }
    let(:ranks)  { [ 1,2,2,4,5,6,7,8,9,9] }
    before { User.stubs(:all).returns(users) }

    context "for a full ranking" do
      before { points.each_with_index {|points, index| users[index].stubs(:total_points).returns(points)} }
      subject { Ranking.new(users) }

      specify { users.map{|user| subject.rank(user)}.should eq ranks }
    end

    context "for a matchday ranking" do
      let(:matchday) { FactoryGirl.build(:matchday) }
      before { points.each_with_index {|points, index| users[index].stubs(:matchday_points).with(matchday).returns(points)} }
      subject { Ranking.new(users, matchday: matchday) }

      specify { users.map{|user| subject.rank(user)}.should eq ranks }
    end

    context "for a ranking fragment" do

      before { points.each_with_index {|points, index| users[index].stubs(:total_points).returns(points)} }

      context "should be correct for a user from the middle of the ranking" do
        subject { Ranking.new(users).fragment_for(users[0], radius: 2).map{|element| element.rank} }
        it { should eq [1,2,2,4,9,9] }
      end

      context "should be correct for a user from the top of the ranking" do
        subject { Ranking.new(users).fragment_for(users[5], radius: 1).map{|element| element.rank} }
        it { should eq [1,5,6,7,9,9] }
      end

      context "should be correct for a user from the bottom of the ranking" do
        subject { Ranking.new(users).fragment_for(users[7], radius: 1).map{|element| element.rank} }
        it { should eq [1,7,8,9,9] }
      end

    end

  end

end
