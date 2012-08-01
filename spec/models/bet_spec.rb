require 'spec_helper'

describe Bet do

  let(:match) { Match.new(score_a: 1, score_b: 2)}
  let(:bet) { Bet.new(score_a: 1, score_b: 2, match: match)}

  describe "result" do

    it "should be correct for incomplete bets" do
      bet.score_b = nil
      bet.result.should == :incomplete
    end

    it "should be correct for incomplete matches" do
      match.score_a = nil
      bet.result.should == :incomplete
    end

    it "should be correct for a totally correct bet" do
      bet.result.should == :correct_result
    end

    it "should be correct for a correct goal difference" do
      bet.score_a = 2
      bet.score_b = 3
      bet.result.should == :correct_goal_difference
    end

    it "should be correct for a correct tendency" do
      bet.score_a = 1
      bet.score_b = 3
      bet.result.should == :correct_tendency
    end

    it "should be correct for a incorrect tendency" do
      bet.score_a = 2
      bet.score_b = 1
      bet.result.should == :incorrect
    end
  end

  it "should compute points correctly" do
    bet.stubs(:result).returns(:correct_result)
    bet.points.should == 3
    bet.stubs(:result).returns(:correct_goal_difference)
    bet.points.should == 2
    bet.stubs(:result).returns(:correct_tendency)
    bet.points.should == 1
    bet.stubs(:result).returns(:incorrect)
    bet.points.should == 0
    bet.stubs(:result).returns(:incomplete)
    bet.points.should == 0
  end
end
