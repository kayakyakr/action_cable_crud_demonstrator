FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@example.com"}
    password "password"
    sequence(:name) {|n| "user #{n}"}
  end
end
