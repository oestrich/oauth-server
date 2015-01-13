class ClientApplication < ActiveRecord::Base
  has_many :authorizations
  has_many :access_tokens, :through => :authorizations

  after_initialize do
    self[:client_id] ||= SecureRandom.uuid
    self[:client_secret] ||= SecureRandom.uuid
  end
end
