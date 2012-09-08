require 'spec_helper'

describe SessionsController do

  describe "GET new" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
      after { get(:new) }
    end

    context "loading the page" do
      before { get(:new) }
      it { should respond_with(:success) }
    end

  end

  context "POST create" do

    let(:user) { FactoryGirl.build(:user) }

    context "active filters" do
      before { User.stubs(:find_by_email).returns(user) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
      after { post(:create, user: {}) }
    end

    context "successful login" do

      before { User.stubs(:find_by_email).with("email").returns(user) }
      before { User.any_instance.stubs(:authenticate).with("password").returns(true) }

      context "redirecting to 'home'" do
        before { post(:create, user: {email: "email", password: "password"}) }
        it { should redirect_to home_path }
      end

      context "remembering the user" do
        after { post(:create, user: {email: "email", password: "password", remember_me: "1"}) }
        specify { controller.expects(:login!).with(user, permanent: true) }
      end

      context "not remembering the user" do
        after { post(:create, user: {email: "email", password: "password", remember_me: "0"}) }
        specify { controller.expects(:login!).with(user, permanent: false) }
      end

    end

    context "unsuccessful login attempt" do

      context "with an invalid email" do

        before { User.stubs(:find_by_email).with("email").returns(nil) }

        context "no login" do
          after { post(:create, user: {email: "email", password: "password"}) }
          specify { controller.expects(:login!).never }
        end

        context "re-render template 'new'" do
          before { post(:create, user: {email: "email", password: "password"}) }
          it { should render_template :new }
        end

      end

      context "with a valid email but an invalid password" do

        before { User.stubs(:find_by_email).with("email").returns(nil) }
        before { User.any_instance.stubs(:authenticate).with("password").returns(false) }

        context "no login" do
          after { post(:create, user: {email: "email", password: "password"}) }
          specify { controller.expects(:login!).never }
        end

        context "re-render template 'new'" do
          before { post(:create, user: {email: "email", password: "password"}) }
          it { should render_template :new }
        end

      end

    end

  end

  describe "DELETE destroy" do

    context "active filters" do
      after { delete(:destroy) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
    end

    context "logging out" do
      after { delete(:destroy) }
      specify { controller.expects(:logout!) }
    end

  end

end
