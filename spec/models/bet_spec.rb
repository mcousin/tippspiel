require 'spec_helper'

describe Bet do

  context "associations" do
    it { should belong_to(:match) }
    it { should belong_to(:user) }
  end

  context "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:match) }
    it { should_not validate_presence_of(:score_a) }
    it { should_not validate_presence_of(:score_b) }
    it { should validate_numericality_of(:score_a).only_integer }
    it { should validate_numericality_of(:score_b).only_integer }
    it { should validate_uniqueness_of(:match_id).scoped_to(:user_id)}

    context "reject changes once the match has started" do
      before { FactoryGirl.create(:bet) }
      before { Match.any_instance.stubs(:has_started?).returns(true) }
      before { Bet.any_instance.stubs(:changes).returns({score_a: [1,2]})}
      specify { Bet.first.should_not be_valid }
    end
  end

  context "method result" do

    subject { FactoryGirl.build(:bet) }

    context "an incomplete bet" do
      [:score_a=, :score_b=].each do |attribute|
        before { subject.send(attribute, nil) }
        its(:result) { should eq :incomplete }
      end
    end

    context "an bet with incomplete match" do
      [:score_a=, :score_b=].each do |attribute|
        before { subject.match.send(attribute, nil) }
        its(:result) { should eq :incomplete }
      end
    end

    context "correctly guessed th result" do
      before { subject.score_a, subject.score_b = [2,1] }
      before { subject.match.score_a, subject.match.score_b = [2,1] }
      its(:result) { should eq :correct_result }
    end

    context "correctly guessed the goal difference" do
      before { subject.score_a, subject.score_b = [1,0] }
      before { subject.match.score_a, subject.match.score_b = [2,1] }
      its(:result) { should eq :correct_goal_difference }
    end

    context "correctly guessed the tendency" do
      before { subject.score_a, subject.score_b = [1,0] }
      before { subject.match.score_a, subject.match.score_b = [2,0] }
      its(:result) { should eq :correct_tendency }
    end

    context "guessed the wrong tendency" do
      before { subject.score_a, subject.score_b = [1,0] }
      before { subject.match.score_a, subject.match.score_b = [0,0] }
      its(:result) { should eq :incorrect }
    end

  end

  context "method points" do

    subject { FactoryGirl.build(:bet) }
    expected_points = {correct_result: 3, correct_goal_difference: 2, correct_tendency: 1, incorrect: 0, incomplete: 0}

    expected_points.each do |result, points|
      context "result" do
        before { subject.stubs(:result).returns(result) }
        its(:points) { should eq points }
      end
    end

  end

end
