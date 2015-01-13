Rails.application.routes.draw do
  scope :oauth do
    get :authorize, :to => "oauth#authorize", :as => :oauth_authorize, :format => false

    post :token, :to => "oauth_tokens#authorization_code", :format => false,
      :constraints => -> (request) { request.parameters["grant_type"] == "authorization_code" }
    post :token, :to => "oauth_tokens#refresh_token", :format => false,
      :constraints => -> (request) { request.parameters["grant_type"] == "refresh_token" }
  end

  resources :authorizations, :only => :update

  resources :sessions, :only => [:new, :create]

  resources :users, :only => [] do
    collection do
      get :me, :format => false
    end
  end

  root :to => "home#index"
end
