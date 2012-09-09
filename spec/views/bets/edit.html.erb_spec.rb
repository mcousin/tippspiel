# require 'spec_helper'
#
# describe "bets/edit" do
#   before(:each) do
#     @bet = assign(:bet, stub_model(Bet,
#       :match_id => 1,
#       :user_id => 1,
#       :score_a => 1,
#       :score_b => 1
#     ))
#   end
#
#   it "renders the edit bet form" do
#     render
#
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => bets_path(@bet), :method => "post" do
#       assert_select "input#bet_match_id", :name => "bet[match_id]"
#       assert_select "input#bet_user_id", :name => "bet[user_id]"
#       assert_select "input#bet_score_a", :name => "bet[score_a]"
#       assert_select "input#bet_score_b", :name => "bet[score_b]"
#     end
#   end
# end
