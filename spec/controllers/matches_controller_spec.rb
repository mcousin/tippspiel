require 'spec_helper'

describe MatchesController do

  let(:user) { FactoryGirl.create(:user, role: 1) }
  before { session[:user_id] = user.id}

  context "GET" do

    let(:match) { FactoryGirl.create(:match) }

    context "index" do
      it "assigns all matches as @matches" do
        match
        get :index, {}
        assigns(:matches).should eq([match])
      end
    end

    context "show" do
      it "assigns the requested match as @match" do
        get :show, {:id => match.to_param}
        assigns(:match).should eq(match)
      end
    end

    context "new" do
      it "assigns a new match as @match" do
        get :new, {}
        assigns(:match).should be_a_new(Match)
      end
    end

    context "edit" do
      it "assigns the requested match as @match" do
        get :edit, {:id => match.to_param}
        assigns(:match).should eq(match)
      end
    end
  end

  context "POST create" do

    context "with valid params" do

      before(:each) do
        @match = FactoryGirl.build(:match)
        Match.expects(:new).with("some" => "attributes").returns(@match)
      end

      it "creates a new Match" do
        @match.expects(:save)
        post(:create, :match => {"some" => "attributes"})
      end

      it "assigns a newly created match as @match" do
        post :create, {:match => {"some" => "attributes"}}
        should assign_to(:match)
      end

      it "redirects to the created match" do
        post :create, {:match => {"some" => "attributes"}}
        response.should redirect_to(@match)
      end

      it "should set the flash" do
        post :create, {:match => {"some" => "attributes"}}
        should set_the_flash[:notice].to('Match was successfully created.')
      end

    end

    context "with invalid params" do
      it "assigns a newly created but unsaved match as @match" do
        Match.any_instance.expects(:save).returns(false)
        post :create, {:match => {}}
        assigns(:match).should be_a_new(Match)
      end

      it "re-renders the 'new' template" do
        Match.any_instance.expects(:save).returns(false)
        post :create, {:match => {}}
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
        put :update, {:id => match.to_param, :match => {'these' => 'params'}}
      end

      it "assigns the requested match as @match" do
        put :update, {:id => match.to_param, :match => valid_attributes}
        assigns(:match).should eq(match)
      end

      it "redirects to the match" do
        put :update, {:id => match.to_param, :match => valid_attributes}
        response.should redirect_to(match)
      end
    end

    context "with invalid params" do
      it "assigns the match as @match" do
        Match.any_instance.expects(:save).returns(false)
        put :update, {:id => match.to_param, :match => {}}
        assigns(:match).should eq(match)
      end

      it "re-renders the 'edit' template" do
        Match.any_instance.expects(:save).returns(false)
        put :update, {:id => match.to_param, :match => {}}
        response.should render_template("edit")
      end
    end
  end

  context "DELETE destroy" do
    it "destroys the requested match" do
      match = FactoryGirl.create(:match)
      expect {
        delete :destroy, {:id => match.to_param}
      }.to change(Match, :count).by(-1)
    end

    it "redirects to the matches list" do
      match = FactoryGirl.create(:match)
      delete :destroy, {:id => match.to_param}
      response.should redirect_to(matches_url)
    end
  end

end
