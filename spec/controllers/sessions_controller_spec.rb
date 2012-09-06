require 'spec_helper'

describe SessionsController do

  context "GET new" do
    it "should be successful" do
      get(:new)
      response.should be_successful
    end
  end

  context "POST create" do
    context "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { post(:create, user: {email: user.email, password: user.password}) }

      it "should log the user in" do
        session[:user_id].should eq(user.id)
      end

      it "should assign the user as @user" do
        assigns(:user).should eq(user)
      end

      it "should redirect to users/home" do
        response.should redirect_to "/home"
      end
    end

    context "with invalid credentials" do

      before(:each) { post(:create, user: {}) }

      it "should re-render the 'new' template" do
        response.should render_template :new
      end
    end

  end

  context "DELETE destroy" do

    it "should log the user out" do
      session[:user_id] = 1
      delete(:destroy)
      session[:user_id].should be_nil
    end
  end

end
