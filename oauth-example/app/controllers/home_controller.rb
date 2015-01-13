class HomeController < ApplicationController
  before_filter :require_token

  def index
    response = client.get("/users/me")

    if response.status == 401
      redirect_to "/auth/homemade"
      return
    end

    json = JSON.parse(response.body)
    render :text => "Welcome #{json["email"]}"
  end

  private

  def require_token
    unless session[:access_token]
      redirect_to "/auth/homemade"
    end
  end

  def client
    @client ||= Faraday.new("http://localhost:5000") do |conn|
      conn.use Middleware, :token => session[:access_token]
      conn.adapter Faraday.default_adapter
    end
  end

  class Middleware < Faraday::Middleware
    def initialize(app, options)
      @app = app
      @options = options
    end

    def call(env)
      env[:request_headers]["Authorization"] = "Bearer #{@options[:token]}"

      @app.call(env)
    end
  end
end
