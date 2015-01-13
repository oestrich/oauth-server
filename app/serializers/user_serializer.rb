class UserSerializer < ActiveModel::Serializer
  root false

  attributes :id, :email
end
