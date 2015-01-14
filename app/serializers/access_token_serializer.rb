class AccessTokenSerializer < ActiveModel::Serializer
  root false

  attributes :access_token, :refresh_token, :expires_in, :token_type

  def token_type
    "bearer"
  end
end
