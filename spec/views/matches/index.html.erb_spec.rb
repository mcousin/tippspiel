require 'spec_helper'

describe "matches/index" do
  before(:each) do
    assign(:matches, [
      stub_model(Match,
        :team_a => "Team A",
        :team_b => "Team B",
        :score_a => 1,
        :score_b => 2
      ),
      stub_model(Match,
        :team_a => "Team A",
        :team_b => "Team B",
        :score_a => 1,
        :score_b => 2
      )
    ])
  end

  it "renders a list of matches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Team A".to_s, :count => 2
    assert_select "tr>td", :text => "Team B".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
