class RemoveTeamBFromMatch < ActiveRecord::Migration
  def up
    remove_column :matches, :team_b
  end

  def down
    add_column :matches, :team_b, :string
  end
end
