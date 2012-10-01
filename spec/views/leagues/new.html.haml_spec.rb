require 'spec_helper'

describe "leagues/new" do
  before(:each) do
    assign(:league, stub_model(League).as_new_record)
  end

  it "renders new league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => leagues_path, :method => "post" do
    end
  end
end
