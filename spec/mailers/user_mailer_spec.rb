require "spec_helper"

describe UserMailer do

  context "password resets email" do
    let(:user) { FactoryGirl.build(:user) }
    subject { UserMailer.password_reset(user).deliver }
    specify { pending("Mailer not yet configured."); UserMailer.deliveries.should_not be_empty }
    its(:to) { should eq [user.email] }
    its(:subject) { should eq "Password Reset" }
  end

end
