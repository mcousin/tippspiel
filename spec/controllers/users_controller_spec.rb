require 'spec_helper'

describe UsersController do

  let(:current_user) { FactoryGirl.build(:user) }
  before { controller.stubs(:current_user).returns(current_user) }

  describe "GET home" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:home) }
    end

    context "preparing the view" do
      let(:ranking) { mock("ranking") }
      let(:matchday) { FactoryGirl.build(:matchday) }
      before { User.any_instance.stubs(:ranking_fragment).with(1).returns(ranking) }
      before { Matchday.stubs(:current).returns(matchday) }
      before { get(:home) }
      it { should assign_to(:ranking).with(ranking) }
      it { should assign_to(:matchday).with(matchday) }
      it { should assign_to(:bets) }
    end

  end

  describe "GET index" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:index) }
    end

    describe "preparing the view" do
      let(:ranking) { mock("ranking") }
      before { User.stubs(:ranking).returns(ranking) }
      before { get(:index) }
      it { should assign_to(:ranking).with(ranking) }
    end

  end

  describe "GET show" do

    let(:requested_user) { FactoryGirl.build(:user) }
    before { User.stubs(:find).with('1').returns(requested_user) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:show, id: 1) }
    end

    describe "preparing the view" do
      before { get(:show, id: 1) }
      it { should assign_to(:user).with(requested_user) }
    end

  end


  describe "GET new" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:new) }
    end

    describe "preparing the view" do
      before { get(:new) }
      it { should assign_to(:user).with_kind_of(User) }
    end

  end

  describe "GET edit" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:edit) }
    end

    describe "preparing the view" do
      before { get(:edit) }
      it { should assign_to(:user).with(current_user) }
    end

  end

  describe "POST create" do

    let(:new_user) { FactoryGirl.build(:user) }
    before { new_user; User.stubs(:new).with("some" => "attributes").returns(new_user) } # we have to create user before stubbing the new method

    context "active filters" do
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
      after { post(:create, :user => {"some" => "attributes"}) }
    end

    context "successful creation of a new user" do
      before { User.any_instance.stubs(:save).returns(true) }
      before { post(:create, :user => {"some" => "attributes"}) }
      specify { new_user.should be_logged_in }
      it { should assign_to(:user).with(new_user) }
      it { should redirect_to "/home" }
      it { should set_the_flash[:notice].to("Welcome, #{new_user.name}!")}
    end

    context "unsuccessful attempt to create a new user" do
      before { User.any_instance.stubs(:save).returns(false) }
      before { post(:create, :user => {"some" => "attributes"}) }
      it { should assign_to(:user).with(new_user) }
      it { should render_template :new }
    end

  end

  describe "PUT update" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!).never }
      after { put(:update) }
    end

    context "successful update of the current user" do
      before { User.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(true) }
      before { put(:update, :user => {"some" => "attributes"}) }
      it { should assign_to(:user).with(current_user) }
      it { should redirect_to "/profile" }
      it { should set_the_flash[:notice].to("Your profile was successfully updated.")}
    end

    context "unsuccessful update of the current user" do
      before { User.any_instance.stubs(:update_attributes).with("some" => "attributes").returns(false) }
      before { put(:update, :user => {"some" => "attributes"}) }
      it { should assign_to(:user).with(current_user) }
      it { should render_template :edit }
    end

  end

  describe "DELETE destroy" do

    let(:requested_user) { FactoryGirl.build(:user) }
    before { User.stubs(:find).with('1').returns(requested_user) }

    context "active filters" do
      specify { controller.expects(:authenticate_user!) }
      specify { controller.expects(:authenticate_admin!) }
      after { delete(:destroy, id: 1) }
    end

    context "successful deletion of the requested user" do
      before { User.any_instance.stubs(:admin?).returns(true) }
      before { User.any_instance.expects(:destroy) }
      before { delete(:destroy, id: 1) }
      it { should assign_to(:user).with(requested_user) }
      it { should redirect_to users_url }
      it { should set_the_flash[:notice].to("The user was successfully destroyed.")}
    end

  end

end
