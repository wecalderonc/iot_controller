FactoryBot.define do
  factory :battery_level do
    value { "0001" }

    association :uplink, factory: :uplink
  end
end
