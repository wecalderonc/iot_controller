FactoryBot.define do
  factory :uplink_b_downlink do
    value { Faker::Number.hexadecimal(digits=4) }

    association :uplink, factory: :uplink
  end
end
