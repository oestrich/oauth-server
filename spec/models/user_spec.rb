require 'rails_helper'

describe User do
  let(:user) { User.create(:email => "eric@example.com", :password => "password") }

  context "access tokens" do
    include_context :access_token

    specify "disabling authorizations" do
      user.disable_application!(client_application.id)

      expect(authorization.reload).to be_inactive
    end
  end
end
