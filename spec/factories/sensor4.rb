FactoryBot.define do
  factory :sensor4 do
    value { Faker::Number.hexadecimal(digits: 4) }

    association :uplink, factory: :uplink
  end
end
