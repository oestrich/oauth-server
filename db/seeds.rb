client_application = ClientApplication.create({
  :name => "Test Application",
  :redirect_uri => "http://localhost:5001/auth/homemade/callback",
})

puts client_application.client_id
puts client_application.client_secret

User.create({
  :email => "eric@example.com",
  :password => "password",
})
