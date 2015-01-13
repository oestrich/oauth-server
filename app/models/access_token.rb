class AccessToken < ActiveRecord::Base
  belongs_to :authorization

  delegate :client_application, :user, :scopes, :to => :authorization

  after_initialize do
    self[:access_token] ||= SecureRandom.uuid
    self[:refresh_token] ||= SecureRandom.uuid
    self[:active] = false if self[:active].nil?
    self[:expires_in] ||= 3600.seconds
  end
end
