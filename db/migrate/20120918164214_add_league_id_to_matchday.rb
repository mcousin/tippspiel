class AddLeagueIdToMatchday < ActiveRecord::Migration
  def change
    add_column :matchdays, :league_id, :integer
  end
end
