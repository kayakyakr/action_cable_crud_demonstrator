FactoryGirl.define do
  factory :expense do
    account
    occurred_at { Time.now }
    description "Describing An Expense"
    amount 1.5
    comment "Commenting on an expense"
  end

end
