FactoryGirl.define do
  factory :account do
    user
    sequence(:name) {|n| "Account #{n}" }
  end
end
