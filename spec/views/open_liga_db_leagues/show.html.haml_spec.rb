require 'spec_helper'

describe "open_liga_db_leagues/show" do
  before(:each) do
    @open_liga_db_league = assign(:open_liga_db_league, stub_model(OpenLigaDbLeague))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
