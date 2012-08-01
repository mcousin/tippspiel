require 'spec_helper'

describe "matchdays/edit" do
  before(:each) do
    @matchday = assign(:matchday, stub_model(Matchday))
  end

  it "renders the edit matchday form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => matchdays_path(@matchday), :method => "post" do
    end
  end
end
