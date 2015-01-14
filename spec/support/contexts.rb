shared_context :logged_in do
  let!(:user) do
    User.create(:email => "eric@example.com", :password => "password")
  end

  before do
    visit new_session_path

    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_on "Sign In"
  end
end

shared_context :access_token do
  let!(:client_application) do
    ClientApplication.create({
      :name => "Test Application",
      :redirect_uri => "http://www.example.com/",
    })
  end
  let!(:authorization) do
    user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => ["self"],
      :redirect_uri => client_application.redirect_uri,
    })
  end
  let!(:access_token) do
    authorization.access_tokens.create
  end
end
