Rails.application.routes.draw do
  get "/auth/homemade/callback", :to => "auth#homemade"

  resource :session, :only => :destroy, :format => false

  root :to => "home#index"
end
