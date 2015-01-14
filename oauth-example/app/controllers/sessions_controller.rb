class SessionsController < ApplicationController
  def destroy
    session[:access_token] = nil
    redirect_to root_url
  end
end
