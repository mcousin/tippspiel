class AddHasEndedToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :has_ended, :boolean
  end
end
