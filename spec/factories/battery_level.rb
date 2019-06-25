FactoryBot.define do
  factory :battery_level do
    value { Faker::Number.hexadecimal(digits=4) }

    association :uplink, factory: :uplink
  end
end
