require 'spec_helper'

describe BetsController do

  let(:current_user) { FactoryGirl.build(:user) }
  let(:matchday) { FactoryGirl.build(:matchday) }
  before { controller.stubs(:current_user).returns(current_user) }
  before { Matchday.stubs(:find).with('1').returns(matchday) }


  describe "GET index" do

    before { User.any_instance.stubs(:find_or_build_bets_for_matchday).with(matchday).returns([]) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:index, matchday_id: '1') }
    end

    context "preparing the view" do
      before { get(:index, matchday_id: '1') }
      it { should assign_to(:matchday).with(matchday) }
      it { should assign_to(:bets).with([]) }
    end

  end

  describe "PUT update" do

    let(:match) { FactoryGirl.build(:match) }
    let(:bet) { FactoryGirl.build(:bet) }

    before { request.env["HTTP_REFERER"] = "where_i_came_from" }
    before { Match.stubs(:find_by_id).with('2').returns(match) }
    before { User.any_instance.stubs(:find_or_build_bet_for_match).with(match).returns(bet) }
    before { Bet.any_instance.stubs(:update_attributes).with("some" => "attributes")}

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { put(:update, { matchday_id: '1'}) }
    end

    context "successful updating bets" do
      before { Bet.any_instance.stubs(:errors).returns([])}
      before { put(:update, { matchday_id: '1', bets: {'2' => {"some" => "attributes"} }}) }
      it { should redirect_to "where_i_came_from" }
      it { should set_the_flash[:notice].to 'Your bets were successfully updated.'}
    end

    context "unsuccessful attempt of updating of bets" do
      before { Bet.any_instance.stubs(:errors).returns(["error"])}
      before { put(:update, { matchday_id: '1', bets: {'2' => {"some" => "attributes"} }}) }
      it { should render_template :index }
    end

  end


end
