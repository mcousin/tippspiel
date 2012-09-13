require 'spec_helper'

describe PasswordResetsController do


  describe "GET 'new'" do

    context "active filters" do
      after { get(:new) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
    end

    context "should be successful" do
      before { get(:new) }
      specify { response.should be_successful }
    end

  end

  describe "POST 'create'" do

    context "active filters" do
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
      after { post(:create) }
    end

    context "user exists" do
      let(:user) { FactoryGirl.build(:user) }
      before { User.stubs(:find_by_email).with("email").returns(user)}

      context "sending password reset" do
        after { post(:create, email: "email") }
        specify { User.any_instance.expects(:send_password_reset) }
      end

      context "redirect to root" do
        before { post(:create, email: "email") }
        it { should redirect_to login_path }
      end

    end

    context "user does not exist" do
      before { User.stubs(:find_by_email).with("email").returns(nil)}

      context "not sending password reset" do
        after { post(:create, email: "email") }
        specify { User.any_instance.expects(:send_password_reset).never }
      end

      context "redirect to root" do
        before { post(:create, email: "email") }
        it { should redirect_to login_path }
      end

    end

  end

end
