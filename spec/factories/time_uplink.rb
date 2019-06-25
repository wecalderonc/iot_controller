FactoryBot.define do
  factory :time_uplink do
    value { Faker::Number.hexadecimal(digits=4) }

    association :uplink, factory: :uplink
  end
end
