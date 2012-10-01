require "spec_helper"

describe OpenLigaDbLeaguesController do
  describe "routing" do

    it "routes to #index" do
      get("/open_liga_db_leagues").should route_to("open_liga_db_leagues#index")
    end

    it "routes to #new" do
      get("/open_liga_db_leagues/new").should route_to("open_liga_db_leagues#new")
    end

    it "routes to #show" do
      get("/open_liga_db_leagues/1").should route_to("open_liga_db_leagues#show", :id => "1")
    end

    it "routes to #edit" do
      get("/open_liga_db_leagues/1/edit").should route_to("open_liga_db_leagues#edit", :id => "1")
    end

    it "routes to #create" do
      post("/open_liga_db_leagues").should route_to("open_liga_db_leagues#create")
    end

    it "routes to #update" do
      put("/open_liga_db_leagues/1").should route_to("open_liga_db_leagues#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/open_liga_db_leagues/1").should route_to("open_liga_db_leagues#destroy", :id => "1")
    end

  end
end
