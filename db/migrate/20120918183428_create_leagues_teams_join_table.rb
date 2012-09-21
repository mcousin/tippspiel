class CreateLeaguesTeamsJoinTable < ActiveRecord::Migration

  def change
    create_table :leagues_teams, :id => false do |t|
      t.integer :league_id
      t.integer :team_id
    end
  end

end
