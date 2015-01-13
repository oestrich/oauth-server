require 'rails_helper'

describe "OAuth", :type => :feature do
  let!(:client_application) do
    ClientApplication.create({
      :name => "Test Application",
      :redirect_url => "http://www.example.com/",
    })
  end

  let!(:user) do
    User.create(:email => "eric@example.com", :password => "password")
  end

  let(:state) { SecureRandom.uuid }

  example "Approving an OAuth request" do
    visit oauth_authorize_path({
      :client_id => client_application.client_id,
      :request_type => "code",
      :scope => "orders",
      :state => state,
      :redirect_url => client_application.redirect_url,
    })

    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_on "Sign In"

    expect(page).to have_content("Allow Test Application")
    expect(page).to have_content("View orders")

    click_on "Authorize"

    expect(current_url).to match(/state=#{state}/)
    expect(current_url).to match(/code=/)
  end
end
