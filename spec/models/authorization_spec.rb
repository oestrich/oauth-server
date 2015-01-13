require 'rails_helper'

describe Authorization do
  let!(:user) do
    User.create(:email => "eric@example.com", :password => "password")
  end

  let(:client_application) do
    ClientApplication.create({
      :name => "Test Application",
      :redirect_url => "http://www.example.com/",
    })
  end

  let(:scopes) { ["orders"] }
  let(:state) { SecureRandom.uuid }

  let(:authorization) do
    user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => scopes,
      :redirect_url => "http://example.com/auth/callback",
      :state => state,
    })
  end

  specify "setting the correct redirect_url with extras" do
    expect(authorization.full_redirect_url).
      to eq("http://example.com/auth/callback?code=#{authorization.code}&state=#{state}")
  end

  specify "handling extra query params in the redirect url" do
    authorization.redirect_url = "http://example.com/auth/callback?others=true"

    expect(authorization.full_redirect_url).
      to eq("http://example.com/auth/callback?code=#{authorization.code}&others%5B%5D=true&state=#{state}")
  end
end
