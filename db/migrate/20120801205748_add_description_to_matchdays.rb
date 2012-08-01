class AddDescriptionToMatchdays < ActiveRecord::Migration
  def change
    add_column :matchdays, :description, :string
  end
end
