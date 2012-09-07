require 'spec_helper'

describe MatchdaysController do


  let(:user) { FactoryGirl.create(:user, role: 1) }
  let(:valid_session) { {user_id: user.id} }

  context "GET" do

    let(:matchday) { FactoryGirl.create(:matchday) }

    context "index" do
      it "assigns all matchdays as @matchdays" do
        matchday
        get :index, {}, valid_session
        assigns(:matchdays).should eq([matchday])
      end
    end

    context "show" do
      it "assigns the requested matchday as @matchday" do
        get :show, {:id => matchday.to_param}, valid_session
        assigns(:matchday).should eq(matchday)
      end
    end

    context "new" do
      it "assigns a new matchday as @matchday" do
        get :new, {}, valid_session
        assigns(:matchday).should be_a_new(Matchday)
      end
    end

    context "edit" do
      it "assigns the requested matchday as @matchday" do
        get :edit, {:id => matchday.to_param}, valid_session
        assigns(:matchday).should eq(matchday)
      end
    end
  end

  context "POST create" do

    let(:valid_attributes) { FactoryGirl.build(:matchday).as_json(:only => [:description]) }

    context "with valid params" do
      it "creates a new Matchday" do
        expect {
          post :create, {:matchday => valid_attributes}, valid_session
        }.to change(Matchday, :count).by(1)
      end

      it "assigns a newly created matchday as @matchday" do
        post :create, {:matchday => valid_attributes}, valid_session
        assigns(:matchday).should be_a(Matchday)
        assigns(:matchday).should be_persisted
      end

      it "redirects to the created matchday" do
        post :create, {:matchday => valid_attributes}, valid_session
        response.should redirect_to(Matchday.last)
      end

      it "creates new matches from csv attributes" do
        Match.expects(:build_from_csv).with({ "some" => "attributes" }, col_sep: ";", row_sep: "\r\n").returns([])
        post :create, {:matchday => valid_attributes, :csv => {"some" => "attributes"}}, valid_session
      end

    end

    context "with invalid params" do
      it "assigns a newly created but unsaved matchday as @matchday" do
        Matchday.any_instance.expects(:save).returns(false)
        post :create, {:matchday => {}}, valid_session
        assigns(:matchday).should be_a_new(Matchday)
      end

      it "re-renders the 'new' template" do
        Matchday.any_instance.expects(:save).returns(false)
        post :create, {:matchday => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  context "PUT update" do

    let(:matchday) { FactoryGirl.create(:matchday) }
    let(:valid_attributes) { FactoryGirl.build(:matchday).as_json(:only => [:description]) }

    context "with valid params" do
      it "updates the requested matchday" do
        Matchday.any_instance.expects(:update_attributes).with({'these' => 'params'})
        put :update, {:id => matchday.to_param, :matchday => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested matchday as @matchday" do
        put :update, {:id => matchday.to_param, :matchday => valid_attributes}, valid_session
        assigns(:matchday).should eq(matchday)
      end

      it "redirects to the matchday" do
        put :update, {:id => matchday.to_param, :matchday => valid_attributes}, valid_session
        response.should redirect_to(matchday)
      end

      it "creates new matches from csv attributes" do
        Match.expects(:build_from_csv).with({ "some" => "attributes" }, col_sep: ";", row_sep: "\r\n").returns([])
        put :update, {:id => matchday.to_param, :matchday => valid_attributes, :csv => {"some" => "attributes"}}, valid_session
      end
    end

    context "with invalid params" do
      it "assigns the matchday as @matchday" do
        Matchday.any_instance.expects(:save).returns(false)
        put :update, {:id => matchday.to_param, :matchday => {}}, valid_session
        assigns(:matchday).should eq(matchday)
      end

      it "re-renders the 'edit' template" do
        Matchday.any_instance.expects(:save).returns(false)
        put :update, {:id => matchday.to_param, :matchday => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  context "DELETE destroy" do
    it "destroys the requested matchday" do
      matchday = FactoryGirl.create(:matchday)
      expect {
        delete :destroy, {:id => matchday.to_param}, valid_session
      }.to change(Matchday, :count).by(-1)
    end

    it "redirects to the matchdays list" do
      matchday = FactoryGirl.create(:matchday)
      delete :destroy, {:id => matchday.to_param}, valid_session
      response.should redirect_to(matchdays_url)
    end
  end

end
