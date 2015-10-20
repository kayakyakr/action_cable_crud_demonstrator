class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :destroyed?
end
