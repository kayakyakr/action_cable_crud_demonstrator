class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :description, :account_id, :comment, :amount, :occurred_at, :destroyed?
end
