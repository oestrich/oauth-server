class Authorization < ActiveRecord::Base
  has_many :access_tokens

  belongs_to :client_application
  belongs_to :user

  after_initialize do
    self[:code] ||= SecureRandom.uuid
    self[:active] = true if self[:active].nil?
  end

  def self.find_active_authorization(client_application_id, redirect_uri, scopes)
    where({
      :client_application_id => client_application_id,
      :redirect_uri => redirect_uri,
      :active => true,
    }).where("scopes = ARRAY[?]", scopes.join(",")).first
  end

  def deactivate!
    update(:active => false)
  end

  def inactive?
    active == false
  end

  def deny_redirect_uri
    uri = URI.parse(redirect_uri)
    params = uri.query ? CGI.parse(uri.query) : {}
    uri.query = params.merge({ "error" => "access_denied", "state" => state }).to_param
    uri.to_s
  end

  def full_redirect_uri
    uri = URI.parse(redirect_uri)
    params = uri.query ? CGI.parse(uri.query) : {}
    uri.query = params.merge({ "code" => code, "state" => state }).to_param
    uri.to_s
  end
end
