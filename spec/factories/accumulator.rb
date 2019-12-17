FactoryBot.define do
  factory :accumulator do
    value             { Faker::Number.hexadecimal(digits: 8) }
    wrong_consumption { false }

    association :uplink, factory: :uplink
  end
end
