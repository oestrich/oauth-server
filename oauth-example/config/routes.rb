Rails.application.routes.draw do
  get "/auth/homemade/callback", :to => "auth#homemade"
  root :to => "home#index"
end
