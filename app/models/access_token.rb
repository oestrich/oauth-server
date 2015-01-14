class AccessToken < ActiveRecord::Base
  belongs_to :authorization

  delegate :client_application, :user, :scopes, :to => :authorization

  after_initialize do
    self[:access_token] ||= SecureRandom.uuid
    self[:refresh_token] ||= SecureRandom.uuid
    self[:active] = true if self[:active].nil?
    self[:expires_in] ||= 3600.seconds
  end

  def valid_token?
    authorization.active? && active? && created_at > 1.hours.ago
  end
end
