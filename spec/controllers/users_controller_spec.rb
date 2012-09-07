require 'spec_helper'

describe UsersController do


  context "GET" do

    before(:all) do
      populate_database
    end

    after(:all) do
      clear_database
    end

    let(:user) { User.first }

    before { cookies['auth_token'] = user.auth_token }

    describe "home" do
      it "should assign a ranking fragment as @ranking" do
        get(:home, {})
        assigns(:ranking).should eq(user.ranking_fragment(1))
      end

      it "should assign the current matchday" do
        user = FactoryGirl.create(:user)
        get(:home, {})
        assigns(:matchday).should eq(Matchday.current)
      end

      it "should assign a bet for each of its matches (if a matchday exist) for the current user" do
        matchday = Matchday.current
        get(:home, {})
        assigns(:bets).should eq(user.bets.select{ |bet| bet.match.matchday == matchday })
      end
    end

    describe "index" do
      it "should assign the full ranking as @ranking" do
        get(:home, {})
        assigns(:ranking).should eq(User.ranking)
      end
    end

    describe "show" do
      it "assigns the requested user as @user" do
        requested_user = User.last
        get(:show, {id: requested_user.id})
        assigns(:user).should eq(requested_user)
      end
    end

    describe "new" do
      it "assigns a new user as @user" do
        get(:new, {})
        assigns(:user).should be_a_new(User)
      end
    end

    describe "edit" do
      it "assigns the current user as @user" do
        get(:edit, {})
        assigns(:user).should eq(user)
      end
    end
  end

  describe "POST create" do

    it "creates a new User" do
      expect {
        post :create, user: {name: "name", email: "name@email.com",
                             password: "password", password_confirmation: "password"}
      }.to change(User, :count).by(1)
    end

    it "should login the newly created user and redirect to home" do
      post(:create, user: {name: "name", email: "name@email.com",
                           password: "password", password_confirmation: "password"})
      user = User.last
      cookies['auth_token'].should eq user.auth_token
      response.should redirect_to "/home"
    end

    it "should re-render the new template in case of errors, assigning the invalid user as @user" do
      post(:create, user: {})
      assigns(:user).should be_a_new(User)
      response.should render_template :new
    end

  end

  describe "PUT update" do

    let(:user) { FactoryGirl.create(:user) }

    before { cookies['auth_token'] = user.auth_token }

    it "updates the current user and redirect to profile" do
      User.any_instance.expects(:update_attributes).with({"these" => "params"}).returns(true)
      put(:update, {id: user.id, user: {"these" => "params"}})
      response.should redirect_to "/profile"
    end

    it "should re-render the new template in case of errors, assigning the invalid user as @user" do
      User.any_instance.expects(:update_attributes).with({"these" => "params"}).returns(false)
      put(:update, {id: user.id, user: {"these" => "params"}})
      response.should render_template :edit
    end

  end

  describe "DELETE destroy" do

    let(:user) { FactoryGirl.create(:user) }
    let(:user_to_destroy) { FactoryGirl.create(:user) }

    before { cookies['auth_token'] = user.auth_token }

    it "should reject non-admins" do
      delete(:destroy, {id: user_to_destroy.id})
      response.status.should eq(403)
    end

    it "should destroy the requested user and redirect to users" do
      User.any_instance.expects(:admin?).returns(true)
      delete(:destroy, {id: user_to_destroy.id})
      response.should redirect_to users_url
    end

  end

end
