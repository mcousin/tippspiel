class CreateOpenLigaDbLeagues < ActiveRecord::Migration
  def change
    create_table :open_liga_db_leagues do |t|
      t.string :oldb_league
      t.string :oldb_season
      t.string :league_id

      t.timestamps
    end
  end
end
