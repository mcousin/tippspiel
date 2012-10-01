require "savon"
require "fuzzystringmatch"

class OpenLigaDbLeague < ActiveRecord::Base
  attr_accessible :league_id, :league, :oldb_league, :oldb_season

  belongs_to :league

  SERVICE_URL = "http://www.openligadb.de/Webservices/Sportsdata.asmx?WSDL"

  def import_matches
    unless (matchdays_aligned? and teams_aligned?)
      Rails.logger.error("Failed to import matches: Matchday descriptions are not aligned.") unless matchdays_aligned?
      Rails.logger.error("Failed to import matches: Team names are not aligned.") unless teams_aligned?
      return
    end
    structs_for(:matches).each do |struct|
      league.reload
      home_team = league.teams.find_by_name(struct[:name_team1]) || league.teams.create(name: struct[:name_team1])
      away_team = league.teams.find_by_name(struct[:name_team2]) || league.teams.create(name: struct[:name_team2])
      matchday = league.matchdays.find_or_create_by_description(struct[:group_name])
      match = matchday.matches.find_or_create_by_home_team_id_and_away_team_id(home_team.id, away_team.id)
      update_match(match, struct)
    end
  end

  def update_matches
    league.matches.each do |match|
      struct = structs_for(:matches).find{|struct| struct[:name_team1] == match.home_team.name and
                                                   struct[:name_team2] == match.away_team.name     }
      if struct
        update_match(match, struct)
      else
        Rails.logger.error("Failed to update match '#{match}' (id=#{match.id}): Team names are not aligned.")
      end
    end
  end

  def refresh!
    refresh_structs_for :matches
  end



  private

    def request(method_name, body = {})
      @client ||= Savon.client(SERVICE_URL)
      @client.request(method_name, body: body).body["#{method_name}_response".to_sym]["#{method_name}_result".to_sym]
    end

    def structs_for(resource)
      refresh_structs_for(resource) unless instance_variable_defined?("@structs_for_#{resource}")
      instance_variable_get("@structs_for_#{resource}")
    end

    def refresh_structs_for(*args)
      args.each do |resource|
        case resource
        when :teams
          structs = request(:get_teams_by_league_saison, league_shortcut: oldb_league, league_saison: oldb_season)[:team]
        when :matchdays
          structs = request(:get_avail_groups, league_shortcut: oldb_league, league_saison: oldb_season)[:group]
        when :matches
          structs = request(:get_matchdata_by_league_saison, league_shortcut: oldb_league, league_saison: oldb_season)[:matchdata]
        end
        instance_variable_set("@structs_for_#{resource}", structs)
      end
    end

    def teams_aligned?
      team_names = structs_for(:teams).map{|struct| struct[:team_name]}
      league.teams.all?{|team| team_names.include?(team.name)}
    end

    def matchdays_aligned?
      matchday_descriptions = structs_for(:matchdays).map{|struct| struct[:group_name]}
      league.matchdays.all?{|matchday| matchday_descriptions.include?(matchday.description)}
    end

    def update_match(match, struct)
      match.assign_attributes(score_a: convert_score(struct[:points_team1]),
                              score_b: convert_score(struct[:points_team2]),
                              match_date: struct[:match_date_time_utc],
                              has_ended: struct[:match_is_finished] )
      if match.changed?
        if match.save
          Rails.logger.info("Match '#{match}' successfully updated.")
        else
          Rails.logger.error("Failed to update match '#{match}' (id=#{match.id}): #{match.errors.full_messages}")
        end
      end
    end

    # OLDB sets empty scores to -1, which is converted to nil by this helper method
    def convert_score(score)
      return nil if score.to_i < 0
      score
    end

    # not needed atm, could be useful for auto-align team names or matchday descriptions
    def string_distance(str1, str2)
      jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
      jarow.getDistance(str1, str2)
    end







end
