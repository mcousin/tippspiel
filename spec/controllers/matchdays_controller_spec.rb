require 'spec_helper'

describe MatchdaysController do

  let(:current_user) { FactoryGirl.build(:user) }
  before { controller.stubs(:current_user).returns(current_user) }
  before { User.any_instance.stubs(:admin?).returns(true) }

  context "GET index" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:index) }
    end

    context "preparing the view" do
      let(:matchday) { FactoryGirl.build(:matchday) }
      before { Matchday.stubs(:all).returns([matchday]) }
      before { get(:index) }
      it { should assign_to(:matchdays).with([matchday]) }
    end

  end

  describe "GET show" do

    let(:requested_matchday) { FactoryGirl.build(:matchday) }
    before { Matchday.stubs(:find).with('1').returns(requested_matchday) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:show, id: 1) }
    end

    describe "preparing the view" do
      before { get(:show, id: 1) }
      it { should assign_to(:matchday).with(requested_matchday) }
    end

  end

  describe "GET new" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:new) }
    end

    describe "preparing the view" do
      before { get(:new) }
      it { should assign_to(:matchday).with_kind_of(Matchday) }
    end

  end

  describe "GET edit" do

    let(:requested_matchday) { FactoryGirl.build(:matchday) }
    before { Matchday.stubs(:find).with('1').returns(requested_matchday) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:edit, id: 1) }
    end

    describe "preparing the view" do
      before { get(:edit, id: 1) }
      it { should assign_to(:matchday).with(requested_matchday) }
    end

  end

  describe "POST create" do

    let(:new_matchday) { FactoryGirl.build(:matchday) }
    before { new_matchday; Matchday.stubs(:new).with("some" => "attributes").returns(new_matchday) } # create matchday before stubbing the new method

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { post(:create, matchday: {"some" => "attributes"}) }
    end

    context "sucessful creation of a matchday" do
      before { Matchday.any_instance.stubs(:save).returns(true) }
      before { post(:create, matchday: {"some" => "attributes"}) }
      it { should assign_to(:matchday).with(new_matchday) }
      it { should redirect_to matchdays_path }
      it { should set_the_flash[:notice].to('The matchday was successfully created.')}
    end

    context "unsuccessful signup attempt" do
      before { Matchday.any_instance.stubs(:save).returns(false) }
      before { post(:create, matchday: {"some" => "attributes"}) }
      it { should assign_to(:matchday).with(new_matchday) }
      it { should render_template :new }
    end

    context "creates new matches from csv attributes" do
      specify { Match.expects(:build_from_csv).with("some csv", col_sep: ";", row_sep: "\r\n").returns([]) }
      after { post(:create, {matchday: {"some" => "attributes"}, csv: "some csv"}) }
    end

  end


  describe "PUT update" do

    let(:requested_matchday) { FactoryGirl.build(:matchday) }
    before { Matchday.stubs(:find).with('1').returns(requested_matchday) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { put(:update, id: 1, matchday: {}) }
    end

    context "successful update of the current matchday" do
      before { Matchday.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(true) }
      before { put(:update, id: 1, matchday: {"some" => "attributes"}) }
      it { should assign_to(:matchday).with(requested_matchday) }
      it { should redirect_to matchdays_path }
      it { should set_the_flash[:notice].to("The matchday was successfully updated.")}
    end

    context "unsuccessful update of the current matchday" do
      before { Matchday.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(false) }
      before { put(:update, id: 1, matchday: {"some" => "attributes"}) }
      it { should assign_to(:matchday).with(requested_matchday) }
      it { should render_template :edit }
    end

    context "creates new matches from csv attributes" do
      before { Matchday.any_instance.stubs(:update_attributes).with("some" => "attributes") }
      specify { Match.expects(:build_from_csv).with("some csv", col_sep: ";", row_sep: "\r\n").returns([]) }
      after { post(:update, id: 1, matchday: {"some" => "attributes"}, csv: "some csv") }
    end


  end

  describe "DELETE destroy" do

    let(:requested_matchday) { FactoryGirl.build(:matchday) }
    before { Matchday.stubs(:find).with('1').returns(requested_matchday) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { delete(:destroy, id: 1) }
    end

    context "successful deletion of the requested matchday" do
      before { Matchday.any_instance.expects(:destroy) }
      before { delete(:destroy, id: 1) }
      it { should assign_to(:matchday).with(requested_matchday) }
      it { should redirect_to matchdays_url }
      it { should set_the_flash[:notice].to("The matchday was successfully destroyed.")}
    end

  end

end
