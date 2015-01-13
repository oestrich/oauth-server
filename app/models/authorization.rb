class Authorization < ActiveRecord::Base
  has_many :access_tokens

  belongs_to :client_application
  belongs_to :user

  after_initialize do
    self[:code] ||= SecureRandom.uuid
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
