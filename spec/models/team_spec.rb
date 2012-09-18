require 'spec_helper'

describe Team do

  context "associations" do
    it { should have_many(:home_matches).class_name(Match) }
    it { should have_many(:away_matches).class_name(Match) }
  end
end
