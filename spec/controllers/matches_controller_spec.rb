require 'spec_helper'

describe MatchesController do


  let(:user) { FactoryGirl.create(:user, role: 1) }
  let(:valid_session) { {user_id: user.id} }

  context "GET" do

    let(:match) { FactoryGirl.create(:match) }

    context "index" do
      it "assigns all matches as @matches" do
        match
        get :index, {}, valid_session
        assigns(:matches).should eq([match])
      end
    end

    context "show" do
      it "assigns the requested match as @match" do
        get :show, {:id => match.to_param}, valid_session
        assigns(:match).should eq(match)
      end
    end

    context "new" do
      it "assigns a new match as @match" do
        get :new, {}, valid_session
        assigns(:match).should be_a_new(Match)
      end
    end

    context "edit" do
      it "assigns the requested match as @match" do
        get :edit, {:id => match.to_param}, valid_session
        assigns(:match).should eq(match)
      end
    end
  end

  context "POST create" do

    let(:valid_attributes) { FactoryGirl.build(:match).as_json(:only => [:team_a, :team_b, :match_date, :matchday_id]) }

    context "with valid params" do
      it "creates a new Match" do
        expect {
          post :create, {:match => valid_attributes}, valid_session
        }.to change(Match, :count).by(1)
      end

      it "assigns a newly created match as @match" do
        post :create, {:match => valid_attributes}, valid_session
        assigns(:match).should be_a(Match)
        assigns(:match).should be_persisted
      end

      it "redirects to the created match" do
        post :create, {:match => valid_attributes}, valid_session
        response.should redirect_to(Match.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved match as @match" do
        Match.any_instance.expects(:save).returns(false)
        post :create, {:match => {}}, valid_session
        assigns(:match).should be_a_new(Match)
      end

      it "re-renders the 'new' template" do
        Match.any_instance.expects(:save).returns(false)
        post :create, {:match => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  context "PUT update" do

    let(:match) { FactoryGirl.create(:match) }
    let(:valid_attributes) { FactoryGirl.build(:match).as_json(:only => [:team_a, :team_b, :match_date, :matchday_id]) }

    context "with valid params" do
      it "updates the requested match" do
        Match.any_instance.expects(:update_attributes).with({'these' => 'params'})
        put :update, {:id => match.to_param, :match => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested match as @match" do
        put :update, {:id => match.to_param, :match => valid_attributes}, valid_session
        assigns(:match).should eq(match)
      end

      it "redirects to the match" do
        put :update, {:id => match.to_param, :match => valid_attributes}, valid_session
        response.should redirect_to(match)
      end
    end

    context "with invalid params" do
      it "assigns the match as @match" do
        Match.any_instance.expects(:save).returns(false)
        put :update, {:id => match.to_param, :match => {}}, valid_session
        assigns(:match).should eq(match)
      end

      it "re-renders the 'edit' template" do
        Match.any_instance.expects(:save).returns(false)
        put :update, {:id => match.to_param, :match => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  context "DELETE destroy" do
    it "destroys the requested match" do
      match = FactoryGirl.create(:match)
      expect {
        delete :destroy, {:id => match.to_param}, valid_session
      }.to change(Match, :count).by(-1)
    end

    it "redirects to the matches list" do
      match = FactoryGirl.create(:match)
      delete :destroy, {:id => match.to_param}, valid_session
      response.should redirect_to(matches_url)
    end
  end

end
