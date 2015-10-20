class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :version
end
