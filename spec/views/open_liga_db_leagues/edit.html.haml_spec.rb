require 'spec_helper'

describe "open_liga_db_leagues/edit" do
  before(:each) do
    @open_liga_db_league = assign(:open_liga_db_league, stub_model(OpenLigaDbLeague))
  end

  it "renders the edit open_liga_db_league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => open_liga_db_leagues_path(@open_liga_db_league), :method => "post" do
    end
  end
end
