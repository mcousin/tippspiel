class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :description

      t.timestamps
    end
  end
end
