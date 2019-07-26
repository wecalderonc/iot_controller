FactoryBot.define do
  factory :alarm do
    value { Faker::Number.hexadecimal(digits=4) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    viewed { false }

    association :uplink, factory: :uplink
    association :alarm_type, factory: :alarm_type
  end
end
