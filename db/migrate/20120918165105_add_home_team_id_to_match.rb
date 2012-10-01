class AddHomeTeamIdToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :home_team_id, :integer
  end
end
