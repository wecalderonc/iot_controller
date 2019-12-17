FactoryBot.define do
  factory :accumulator do
    value { Faker::Number.hexadecimal(digits: 8) }
    is_an_overturning { false }

    association :uplink, factory: :uplink
  end
end
