class AddMatchdayIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :matchday_id, :integer
  end
end
