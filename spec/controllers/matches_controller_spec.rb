require 'spec_helper'

describe MatchesController do

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
      let(:match) { FactoryGirl.build(:match) }
      before { Match.stubs(:all).returns([match]) }
      before { get(:index) }
      it { should assign_to(:matches).with([match]) }
    end

  end

  describe "GET show" do

    let(:requested_match) { FactoryGirl.build(:match) }
    before { Match.stubs(:find).with('1').returns(requested_match) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:show, id: 1) }
    end

    describe "preparing the view" do
      before { get(:show, id: 1) }
      it { should assign_to(:match).with(requested_match) }
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
      it { should assign_to(:match).with_kind_of(Match) }
    end

  end

  describe "GET edit" do

    let(:requested_match) { FactoryGirl.build(:match) }
    before { Match.stubs(:find).with('1').returns(requested_match) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { get(:edit, id: 1) }
    end

    describe "preparing the view" do
      before { get(:edit, id: 1) }
      it { should assign_to(:match).with(requested_match) }
    end

  end

  describe "POST create" do

    let(:new_match) { FactoryGirl.build(:match) }
    before { new_match; Match.stubs(:new).with("some" => "attributes").returns(new_match) } # create match before stubbing the new method

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { post(:create, :match => {"some" => "attributes"}) }
    end

    context "sucessful creation of a match" do
      before { Match.any_instance.stubs(:save).returns(true) }
      before { post(:create, :match => {"some" => "attributes"}) }
      it { should assign_to(:match).with(new_match) }
      it { should redirect_to matches_path }
      it { should set_the_flash[:notice].to('The match was successfully created.')}
    end

    context "unsuccessful signup attempt" do
      before { Match.any_instance.stubs(:save).returns(false) }
      before { post(:create, :match => {"some" => "attributes"}) }
      it { should assign_to(:match).with(new_match) }
      it { should render_template :new }
    end

  end


  describe "PUT update" do

    let(:requested_match) { FactoryGirl.build(:match) }
    before { Match.stubs(:find).with('1').returns(requested_match) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { put(:update, id: 1) }
    end

    context "successful update of the current match" do
      before { Match.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(true) }
      before { put(:update, id: 1, :match => {"some" => "attributes"}) }
      it { should assign_to(:match).with(requested_match) }
      it { should redirect_to matches_path }
      it { should set_the_flash[:notice].to("The match was successfully updated.")}
    end

    context "unsuccessful update of the current match" do
      before { Match.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(false) }
      before { put(:update, id: 1, :match => {"some" => "attributes"}) }
      it { should assign_to(:match).with(requested_match) }
      it { should render_template :edit }
    end

  end

  describe "DELETE destroy" do

    let(:requested_match) { FactoryGirl.build(:match) }
    before { Match.stubs(:find).with('1').returns(requested_match) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { delete(:destroy, id: 1) }
    end

    context "successful deletion of the requested match" do
      before { Match.any_instance.expects(:destroy) }
      before { delete(:destroy, id: 1) }
      it { should assign_to(:match).with(requested_match) }
      it { should redirect_to matches_url }
      it { should set_the_flash[:notice].to("The match was successfully destroyed.")}
    end

  end

end
