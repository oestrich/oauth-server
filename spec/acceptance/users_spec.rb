require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  get "/users/me" do
    header "Authorization", :authorization_header

    let(:user) do
      User.create(:email => "eric@example.com", :password => "password")
    end

    let!(:client_application) do
      ClientApplication.create({
        :name => "Test Application",
        :redirect_uri => "http://www.example.com/",
      })
    end

    let(:authorization) do
      user.authorizations.create({
        :client_application_id => client_application.id,
        :scopes => ["self"],
        :redirect_uri => client_application.redirect_uri,
      })
    end

    let(:access_token) do
      authorization.access_tokens.create
    end

    let(:authorization_header) do
      "Bearer #{access_token.access_token}"
    end

    example_request "Viewing information about who i am" do
      expect(status).to eq(200)
      expect(response_body).to be_json_eql({
        :email => "eric@example.com",
      }.to_json)
    end

    context "token expired" do
      before do
        access_token.created_at = 2.hours.ago
        access_token.save
      end

      example_request "Out of date token" do
        expect(status).to eq(401)
      end
    end

    context "token no longer active" do
      before do
        access_token.active = false
        access_token.save
      end

      example_request "Out of date token" do
        expect(status).to eq(401)
      end
    end
  end
end
