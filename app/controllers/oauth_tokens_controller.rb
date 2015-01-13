class OauthTokensController < ApplicationController
  before_filter :require_client_application
  before_filter :set_cache_headers

  protect_from_forgery :only => []

  def authorization_code
    authorization = client_application.authorizations.find_by(:code => params[:code])
    access_token = authorization.access_tokens.create!

    render :json => access_token
  end

  def refresh_token
    access_token =
      client_application.access_tokens.find_by(:refresh_token => params[:refresh_token])
    authorization = access_token.authorization
    access_token = authorization.access_tokens.create!
    render :json => access_token
  end

  private

  attr_reader :authorization
  helper_method :authorization

  def client_application
    return @client_application if @client_application

    if request.headers["Authorization"].present?
      auth_header = request.headers["Authorization"].gsub("Basic ", "")
      client_id, client_secret = Base64.strict_decode64(auth_header).split(":")
      @client_application ||=
        ClientApplication.find_by(:client_id => client_id, :client_secret => client_secret)
    elsif params.has_key?(:client_id) && params.has_key?(:client_secret)
      @client_application ||=
        ClientApplication.find_by({
        :client_id => params[:client_id],
        :client_secret => params[:client_secret],
      })
    end
  end
  helper_method :client_application

  def require_client_application
    unless client_application
      head 401
    end
  end

  def set_cache_headers
    headers["Cache-Control"] = "no-cache"
    headers["Pragma"] = "no-cache"
  end
end
