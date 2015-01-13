require 'homemade-auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :homemade, ENV['HOMEMADE_CLIENT_ID'], ENV['HOMEMADE_CLIENT_SECRET'], {
    :scope => "self",
  }
end
