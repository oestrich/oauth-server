require 'rails_helper'

describe "Connected Applications", :type => :feature do
  include_context :logged_in

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

  example "Viewing connected applications" do
    visit root_url

    click_on "Connected Applications"

    expect(page).to have_selector(".application", :text => "Test Application")
  end

  example "Removing a connected application" do
    visit root_url

    click_on "Connected Applications"
    click_on "Remove"

    expect(page).to have_selector(".application", :count => 0)
  end
end
