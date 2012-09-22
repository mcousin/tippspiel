class RemoveTeamAFromMatch < ActiveRecord::Migration
  def up
    remove_column :matches, :team_a
  end

  def down
    add_column :matches, :team_a, :string
  end
end
