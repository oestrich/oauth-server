require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Tokens" do
  post "/oauth/token" do
    header "Authorization", :authorization_header
    header "Accept", "application/json"

    parameter :grant_type, "Type of grant requested, must be one of: authorization_code"
    parameter :code, "Authorization code"
    parameter :redirect_uri, "Redirect url used to obtain authorization code"

    let!(:client_application) do
      ClientApplication.create({
        :name => "Test Application",
        :redirect_uri => "http://www.example.com/",
      })
    end

    let!(:user) do
      User.create(:email => "eric@example.com", :password => "password")
    end

    let(:authorization) do
      user.authorizations.create({
        :client_application_id => client_application.id,
        :scopes => ["self"],
        :redirect_uri => redirect_uri,
      })
    end

    let(:authorization_header) do
      secret = "#{client_application.client_id}:#{client_application.client_secret}"
      "Basic #{Base64.strict_encode64(secret)}"
    end

    let(:grant_type) { "authorization_code" }
    let(:code) { authorization.code }
    let(:redirect_uri) { client_application.redirect_uri }

    example_request "Turning an authorization code into an access token" do
      expect(status).to eq(200)
      expect(response_headers["Cache-Control"]).to eq("no-cache")
      expect(response_headers["Pragma"]).to eq("no-cache")

      expect(response_body).to be_json_eql({
        :expires_in => 3600,
      }.to_json).excluding("access_token", "refresh_token")
      expect(response_body).to have_json_path("access_token")
      expect(response_body).to have_json_path("refresh_token")
    end
  end
end
