FactoryBot.define do
  factory :city do
    name { Faker::Address.city }

    association :state, factory: :state
  end
end
