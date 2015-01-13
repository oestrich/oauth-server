class UsersController < ApplicationController
  before_filter :require_access_token!
  before_filter :require_self_scope!

  def me
    render :json => access_token.user
  end

  private

  def access_token
    @access_token ||=
      AccessToken.find_by(:access_token => request.headers["Authorization"].gsub("Bearer ", ""))
  end

  def require_access_token!
    unless access_token
      head 401
    end
  end

  def require_self_scope!
    unless access_token.scopes.include?("self")
      head 401
    end
  end
end
