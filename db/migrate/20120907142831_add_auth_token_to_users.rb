class AddAuthTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :auth_token, :string

    User.all.each do |user|
      user.generate_token(:auth_token)
      user.save!
    end
  end

  def down
    remove_column :users, :auth_token
  end
end
