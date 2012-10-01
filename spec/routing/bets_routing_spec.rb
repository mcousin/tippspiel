require "spec_helper"

describe BetsController do
  describe "routing" do

    it "routes to #index" do
      get("/matchdays/1/bets").should route_to("bets#index", matchday_id: "1")
    end

    it "routes to #update" do
      put("/matchdays/1/bets").should route_to("bets#update", matchday_id: "1")
    end

  end
end
