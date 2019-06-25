FactoryBot.define do
  factory :alarm do
    value { Faker::Number.hexadecimal(digits=4) }

    association :uplink, factory: :uplink
  end
end
