class AuthorizationsController < ApplicationController
  before_filter :require_user

  def update
    authorization = current_user.authorizations.find(params[:id])

    if params[:deny]
      authorization.deactivate!
      redirect_to authorization.deny_redirect_uri
    else
      redirect_to authorization.full_redirect_uri
    end
  end
end
