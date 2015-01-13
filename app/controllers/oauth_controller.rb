class OauthController < ApplicationController
  before_filter :require_user, :only => :authorize
  before_filter :require_client_application

  protect_from_forgery :except => [:token]

  def authorize
    @authorization = current_user.authorizations.create({
      :client_application_id => client_application.id,
      :scopes => scopes,
      :redirect_uri => params[:redirect_uri],
      :state => params[:state],
    })
  end

  def token
    headers["Cache-Control"] = "no-cache"
    headers["Pragma"] = "no-cache"

    case params[:grant_type]
    when "authorization_code"
      authorization = client_application.authorizations.find_by(:code => params[:code])
      access_token = authorization.access_tokens.create!
    when "refresh_token"
      access_token =
        client_application.access_tokens.find_by(:refresh_token => params[:refresh_token])
      authorization = access_token.authorization
      access_token = authorization.access_tokens.create!
    end

    if access_token
      render :json => access_token
    else
      head 400
    end
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
      client_id, client_secret = Base64.strict_decode64(auth_header).split(":")
      @client_application ||=
        ClientApplication.find_by(:client_id => client_id, :client_secret => client_secret)
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
