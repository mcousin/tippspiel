class User < ActiveRecord::Base
  attr_accessible :email, :name

  has_secure_password

  def to_s
    "Name: #{name}; E-Mail: #{email}"
  end


end
