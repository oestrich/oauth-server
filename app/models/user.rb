class User < ActiveRecord::Base
  has_secure_password

  has_many :access_tokens
  has_many :authorizations
end
