require 'spec_helper'

describe BetsController do

  let(:user)     { FactoryGirl.create(:user) }
  let(:matchday) { FactoryGirl.create(:matchday) }

  before { cookies['auth_token'] = user.auth_token }


  describe "GET index" do

    it "@matchday should contain the right matchday" do
      get(:index, {matchday_id: matchday.id})
      assigns(:matchday).should eq(matchday)
    end

    it "@bets should containt exactly one bet for each match of the matchday" do
      get(:index, {matchday_id: matchday.id})
      should assign_to(:bets)
    end

  end

  describe "PUT update" do

    let(:match)    { FactoryGirl.create(:match, matchday: matchday) }

    before(:each) { request.env["HTTP_REFERER"] = "where_i_came_from" }

    it "should update existing bets" do
      FactoryGirl.create(:bet, match: match, user: user)
      lambda {
        put(:update, { matchday_id: matchday.id, bets: {match.id => {score_a: 3, score_b: 2} } })
      }.should_not change(Bet, :count)
      user.bets.find_by_match_id(match.id).score_a.should eq(3)
      user.bets.find_by_match_id(match.id).score_b.should eq(2)
    end

    it "should create bets if non-existent" do
      lambda {
        put(:update, { matchday_id: matchday.id, bets: {match.id => {score_a: 3, score_b: 2} } })
      }.should change(Bet, :count).by(1)
    end

    it "should re-render the index template in case of errors, assigning the invalid as @bets" do
      put(:update, { matchday_id: matchday.id, bets: {match.id => {score_a: "xxx"} } })
      assigns(:bets).any?{|bet| bet.match_id == match.id}.should be_true
      response.should render_template :index
    end

    it "should redirect back" do
      put(:update, { matchday_id: matchday.id, bets: {match.id => {score_a: 3, score_b: 2} } })
      response.should redirect_to "where_i_came_from"
    end

  end


end
