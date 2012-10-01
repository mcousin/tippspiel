require 'spec_helper'

describe "open_liga_db_leagues/new" do
  before(:each) do
    assign(:open_liga_db_league, stub_model(OpenLigaDbLeague).as_new_record)
  end

  it "renders new open_liga_db_league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => open_liga_db_leagues_path, :method => "post" do
    end
  end
end
