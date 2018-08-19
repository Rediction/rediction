FactoryBot.define do
  factory :provisional_user do
    sequence(:email) { |n| "example+#{n}@gmail.com" }
    password "password"
    sequence(:verification_token) { | n | "xxxxxxxxxxxxx#{n}" }
  end
end