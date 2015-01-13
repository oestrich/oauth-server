class AccessTokenSerializer < ActiveModel::Serializer
  root false

  attributes :access_token, :refresh_token, :expires_in
end
