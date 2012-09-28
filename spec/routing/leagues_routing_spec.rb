require "spec_helper"

describe LeaguesController do
  describe "routing" do

    it "routes to #index" do
      get("/leagues").should route_to("leagues#index")
    end

    it "routes to #new" do
      get("/leagues/new").should route_to("leagues#new")
    end

    it "routes to #show" do
      get("/leagues/1").should route_to("leagues#show", :id => "1")
    end

    it "routes to #edit" do
      get("/leagues/1/edit").should route_to("leagues#edit", :id => "1")
    end

    it "routes to #create" do
      post("/leagues").should route_to("leagues#create")
    end

    it "routes to #update" do
      put("/leagues/1").should route_to("leagues#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/leagues/1").should route_to("leagues#destroy", :id => "1")
    end

  end
end
