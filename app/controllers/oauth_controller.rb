class OauthController < ApplicationController
  before_filter :require_user, :only => :authorize
  before_filter :require_client_application

  def authorize
    @authorization = current_user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => scopes,
      :redirect_url => params[:redirect_url],
      :state => params[:state],
    })
  end

  def token
    headers["Cache-Control"] = "no-cache"
    headers["Pragma"] = "no-cache"

    authorization = client_application.authorizations.find_by(:code => params[:code])
    access_token = authorization.access_tokens.create!

    render :json => access_token
  end

  private

  attr_reader :authorization
  helper_method :authorization

  def client_application
    return @client_application if @client_application

    if params.has_key?(:client_id)
      @client_application ||= ClientApplication.find_by(:client_id => params[:client_id])
    elsif request.headers["Authorization"].present?
      auth_header = request.headers["Authorization"].gsub("Basic ", "")
      client_id, _ = Base64.strict_decode64(auth_header).split(":")
      @client_application ||= ClientApplication.find_by(:client_id => client_id)
    end
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
