class HomeController < ApplicationController
  def index
    return unless session[:access_token]

    response = client.get("/users/me")

    if response.success?
      json = JSON.parse(response.body)
      @email = json["email"]
    end
  end

  private

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
