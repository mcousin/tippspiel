require 'spec_helper'

describe League do

  context "associations" do
    it { should have_and_belong_to_many(:teams) }
    it { should have_many(:matchdays) }
    it { should have_many(:matches).through(:matchdays) }
    it { should have_one(:open_liga_db_league) }
  end

end
