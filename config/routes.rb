Rails.application.routes.draw do
  scope :oauth do
    get :authorize, :to => "oauth#authorize", :as => :oauth_authorize, :format => false
    post :token, :to => "oauth#token", :as => :oauth_token, :format => false
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
