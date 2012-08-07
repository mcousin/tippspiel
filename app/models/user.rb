class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role

  has_secure_password
  has_many :bets

end
