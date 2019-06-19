FactoryBot.define do
  factory :sensor1 do
    value { Faker::Number.hexadecimal(digits=4) }

    association :uplink, factory: :uplink
  end
end
