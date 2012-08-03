class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password
  has_many :bets

  def to_s
    "Name: #{name}; E-Mail: #{email}"
  end


end
