require 'spec_helper'

describe User do

  let(:user) { User.new(:name => "Jan", :email => "jan@tippspiel.de")}

  it "should authenticate a user correctly" do
    user.password = "correct password"
    user.authenticate("wrong password").should be_false
    user.authenticate("correct password").should eq user
  end
  
  it "should compute ranks correctly" do
    user1 = mock("user1")
    user2 = mock("user2")
    user3 = mock("user3")
    
    User.stubs(:all).returns([user1, user2, user3])
    user1.stubs(:points).returns(2)
    user2.stubs(:points).returns(4)
    user3.stubs(:points).returns(4)

    ranking = User.get_ranking
    ranking[user1].should eq(3)
    ranking[user2].should eq(1)
    ranking[user3].should eq(1)
    
  end
end
