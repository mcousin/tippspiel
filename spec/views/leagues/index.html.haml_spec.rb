require 'spec_helper'

describe "leagues/index" do
  before(:each) do
    assign(:leagues, [
      stub_model(League),
      stub_model(League)
    ])
  end

  it "renders a list of leagues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
