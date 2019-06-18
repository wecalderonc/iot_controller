FactoryBot.define do
  factory :accumulator do
    value { rand(1000) }

    association :uplink, factory: :uplink
  end
end
