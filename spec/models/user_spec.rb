require 'spec_helper'

describe User do

  let(:user) { User.new(:name => "Jan", :email => "jan@tippspiel.de")}
  it "should have a to_s method showing name and email" do
    user.to_s.should eq "Name: #{user.name}; E-Mail: #{user.email}"
  end
end
