class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :team_a
      t.string :team_b
      t.integer :score_a
      t.integer :score_b
      t.datetime :match_date

      t.timestamps
    end
  end
end
