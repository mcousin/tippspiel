class AddAwayTeamIdToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :away_team_id, :integer
  end
end
