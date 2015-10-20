class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role
end
