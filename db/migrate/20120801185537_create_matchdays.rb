class CreateMatchdays < ActiveRecord::Migration
  def change
    create_table :matchdays do |t|

      t.timestamps
    end
  end
end
