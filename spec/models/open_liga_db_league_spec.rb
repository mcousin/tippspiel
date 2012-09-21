require 'spec_helper'

describe OpenLigaDbLeague do

  context "associations" do
    it { should belong_to(:league) }
  end

  context "methods" do
    let(:oldb_league) { FactoryGirl.create(:oldb_league, oldb_league: "bl1", oldb_season: "2012") }

    context "import_matches" do
      context "fail if teams are not aligned"
      context "fail if matchdays are not aligned"
      context "create match only if missing" do
        context "if match exists"
        context "if match does not exists"
      end
      context "create team only if missing" do
        context "if team exists"
        context "if team does not exist"
      end
      context "create matchday only if missing" do
        context "if matchday exists"
        context "if matchday does not exist"
      end
    end

    context "update_matches" do

      let(:matchday) { FactoryGirl.create(:matchday, league: oldb_league.league) }
      let(:home_team) { FactoryGirl.create(:team, name: "Borussia Dortmund") }
      let(:away_team) { FactoryGirl.create(:team, name: "Werder Bremen") }
      before { @match = FactoryGirl.create(:match, matchday: matchday, home_team: home_team, away_team: away_team) }

      context "with a result" do
        before do
          OpenLigaDbLeague.any_instance.stubs(:structs_for).with(:matches).returns(
                  [ {points_team1: "2", points_team2: "1", match_date_time_utc: DateTime.new(2012),
                     name_team1: home_team.name, name_team2: away_team.name} ] )
          oldb_league.update_matches
        end

        subject { @match.reload }
        its(:score_a) { should eq 2 }
        its(:score_b) { should eq 1 }
        its(:match_date) { should eq DateTime.new(2012) }
      end

      context "without a result" do
        before do
          OpenLigaDbLeague.any_instance.stubs(:structs_for).with(:matches).returns(
                  [ {points_team1: "-1", points_team2: "-1", match_date_time_utc: DateTime.new(2012),
                     name_team1: home_team.name, name_team2: away_team.name} ] )
          oldb_league.update_matches
        end

        subject { @match.reload }
        its(:score_a) { should be_nil }
        its(:score_b) { should be_nil }
        its(:match_date) { should eq DateTime.new(2012) }
      end

    end

    context "private methods" do

      context "structs_for" do
        context "teams" do
          subject { oldb_league.send(:structs_for, :teams) }
          its(:count) { should eq 18 }
          specify { subject.first[:team_name].should be_a(String) }
        end
        context "matches" do
          subject { oldb_league.send(:structs_for, :matches) }
          its(:count) { should eq 34*9 }
          specify { subject.first[:name_team1].should be_a(String) }
          specify { subject.first[:name_team2].should be_a(String) }
          specify { subject.first[:points_team1].should be_a(String) }
          specify { subject.first[:points_team2].should be_a(String) }
          specify { subject.first[:group_name].should be_a(String) }
          specify { subject.first[:match_date_time_utc].should be_a(DateTime) }
        end
        context "matchdays" do
          subject { oldb_league.send(:structs_for, :matchdays) }
          its(:count) { should eq 34 }
          specify { subject.first[:group_name].should be_a(String) }
        end
      end

    end


  end



end
