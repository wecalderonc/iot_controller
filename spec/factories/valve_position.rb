FactoryBot.define do
  factory :valve_position do
    value { Faker::Number.hexadecimal(digits: 4) }

    association :uplink, factory: :uplink
  end
end
