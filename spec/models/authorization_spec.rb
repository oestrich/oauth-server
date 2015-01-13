require 'rails_helper'

describe Authorization do
  let!(:user) do
    User.create(:email => "eric@example.com", :password => "password")
  end

  let(:client_application) do
    ClientApplication.create({
      :name => "Test Application",
      :redirect_uri => "http://www.example.com/",
    })
  end

  let(:scopes) { ["self"] }
  let(:state) { SecureRandom.uuid }

  let(:authorization) do
    user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => scopes,
      :redirect_uri => "http://example.com/auth/callback",
      :state => state,
    })
  end

  specify "setting the correct redirect_uri with extras" do
    expect(authorization.full_redirect_uri).
      to eq("http://example.com/auth/callback?code=#{authorization.code}&state=#{state}")
  end

  specify "handling extra query params in the redirect url" do
    authorization.redirect_uri = "http://example.com/auth/callback?others=true"

    expect(authorization.full_redirect_uri).
      to eq("http://example.com/auth/callback?code=#{authorization.code}&others%5B%5D=true&state=#{state}")
  end
end
