class ClientApplication < ActiveRecord::Base
  has_many :authorizations

  after_initialize do
    self[:client_id] ||= SecureRandom.uuid
    self[:client_secret] ||= SecureRandom.uuid
  end
end
