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
        cookies['auth_token'].should eq(user.auth_token)
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
      cookies['auth_token'] = 1
      delete(:destroy)
      cookies['auth_token'].should be_nil
    end
  end

end
