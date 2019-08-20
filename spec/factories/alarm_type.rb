FactoryBot.define do
  factory :alarm_type do
    name { Faker::Movie.quote }
    type { Faker::Movie.quote }
    value { Faker::Number.number(digits: 3) }
  end
end
