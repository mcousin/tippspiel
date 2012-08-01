require "spec_helper"

describe MatchdaysController do
  describe "routing" do

    it "routes to #index" do
      get("/matchdays").should route_to("matchdays#index")
    end

    it "routes to #new" do
      get("/matchdays/new").should route_to("matchdays#new")
    end

    it "routes to #show" do
      get("/matchdays/1").should route_to("matchdays#show", :id => "1")
    end

    it "routes to #edit" do
      get("/matchdays/1/edit").should route_to("matchdays#edit", :id => "1")
    end

    it "routes to #create" do
      post("/matchdays").should route_to("matchdays#create")
    end

    it "routes to #update" do
      put("/matchdays/1").should route_to("matchdays#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/matchdays/1").should route_to("matchdays#destroy", :id => "1")
    end

  end
end
