class OauthController < ApplicationController
  before_filter :require_user
  before_filter :require_client_application

  def authorize
    authorization = current_user.authorizations.
      find_active_authorization(client_application.id, params[:redirect_uri],scopes)

    if authorization
      authorization.deactivate!
      authorization = create_authorization
      redirect_to authorization.full_redirect_uri
    else
      @authorization = create_authorization
    end
  end

  private

  attr_reader :authorization
  helper_method :authorization

  def create_authorization
    current_user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => scopes,
      :redirect_uri => params[:redirect_uri],
      :state => params[:state],
    })
  end

  def client_application
    @client_application ||= ClientApplication.find_by(:client_id => params[:client_id])
  end
  helper_method :client_application

  def scopes
    params[:scope].split(" ")
  end

  def require_client_application
    unless client_application
      render :error, :status => 401
    end
  end
end
