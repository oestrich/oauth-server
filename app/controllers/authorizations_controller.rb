class AuthorizationsController < ApplicationController
  before_filter :require_user

  def update
    authorization = current_user.authorizations.find(params[:id])
    redirect_to authorization.full_redirect_url
  end
end
