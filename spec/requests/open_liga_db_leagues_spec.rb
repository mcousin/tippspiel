require 'spec_helper'

describe "OpenLigaDbLeagues" do
  describe "GET /open_liga_db_leagues" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get open_liga_db_leagues_path
      response.status.should be(200)
    end
  end
end
