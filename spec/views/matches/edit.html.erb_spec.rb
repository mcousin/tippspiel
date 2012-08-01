require 'spec_helper'

describe "matches/edit" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :team_a => "MyString",
      :team_b => "MyString",
      :score_a => 1,
      :score_b => 1
    ))
  end

  it "renders the edit match form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => matches_path(@match), :method => "post" do
      assert_select "input#match_team_a", :name => "match[team_a]"
      assert_select "input#match_team_b", :name => "match[team_b]"
      assert_select "input#match_score_a", :name => "match[score_a]"
      assert_select "input#match_score_b", :name => "match[score_b]"
    end
  end
end
