require 'spec_helper'

describe "open_liga_db_leagues/index" do
  before(:each) do
    assign(:open_liga_db_leagues, [
      stub_model(OpenLigaDbLeague),
      stub_model(OpenLigaDbLeague)
    ])
  end

  it "renders a list of open_liga_db_leagues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
