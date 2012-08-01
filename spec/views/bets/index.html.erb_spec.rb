require 'spec_helper'

describe "bets/index" do
  before(:each) do
    assign(:bets, [
      stub_model(Bet,
        :match_id => 1,
        :user_id => 2,
        :score_a => 3,
        :score_b => 4
      ),
      stub_model(Bet,
        :match_id => 1,
        :user_id => 2,
        :score_a => 3,
        :score_b => 4
      )
    ])
  end

  it "renders a list of bets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
