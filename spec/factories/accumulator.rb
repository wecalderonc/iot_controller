FactoryBot.define do
  factory :accumulator do
    value { Faker::Number.hexadecimal(digits: 8) }

    association :uplink, factory: :uplink
  end
end
