require 'spec_helper'

describe PasswordResetsController do


  describe "GET 'new'" do

    context "active filters" do
      after { get(:new) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
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

  describe "GET 'edit'" do

    let(:user) { FactoryGirl.create(:user) }
    before { User.stubs(:find_by_password_reset_token!).with('1').returns(user) }

    context "active filters" do
      after { get(:edit, id: 1) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
    end

    context "assigning the user as @user" do
      before { get(:edit, id: 1) }
      it { should assign_to(:user).with(user) }
    end

  end

  describe "PUT 'update'" do

    let(:user) { FactoryGirl.create(:user) }
    before { user.send_password_reset }

    context "active filters" do
      after { put(:update, id: user.password_reset_token) }
      specify { controller.expects(:authenticate_user!).never }
      specify { controller.expects(:authenticate_admin!).never }
    end

    context "redirecting to login path in case of successful update" do
      before { User.any_instance.stubs(:update_attributes).returns(true) }
      before { put(:update, id: user.password_reset_token) }
      it { should redirect_to login_path }
      it { should set_the_flash[:notice].to("Password has been reset.")}
    end

    context "redirecting to new password reset path in case of an expired token" do
      before { User.any_instance.stubs(:password_reset_sent_at).returns(3.hours.ago) }
      before { put(:update, id: user.password_reset_token) }
      it { should redirect_to new_password_reset_path }
      it { should assign_to(:user).with(user) }
      it { should set_the_flash[:notice].to("Password reset has expired.")}
    end


    context "re-rendering the edit page in case of invalid password" do
      before { User.any_instance.stubs(:update_attributes).returns(false) }
      before { put(:update, id: user.password_reset_token) }
      it { should render_template :edit }
      it { should assign_to(:user).with(user) }
    end


  end


end
