require 'spec_helper'

describe "matchdays/index" do
  before(:each) do
    assign(:matchdays, [
      stub_model(Matchday),
      stub_model(Matchday)
    ])
  end

  it "renders a list of matchdays" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
