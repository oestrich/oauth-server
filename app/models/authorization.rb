class Authorization < ActiveRecord::Base
  has_many :access_tokens

  belongs_to :client_application
  belongs_to :user

  after_initialize do
    self[:code] ||= SecureRandom.uuid
  end

  def full_redirect_url
    uri = URI.parse(redirect_url)
    params = uri.query ? CGI.parse(uri.query) : {}
    uri.query = params.merge({ "code" => code, "state" => state }).to_param
    uri.to_s
  end
end
