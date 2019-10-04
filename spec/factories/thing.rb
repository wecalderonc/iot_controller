FactoryBot.define do
  factory :thing do
    name { Faker::Alphanumeric.alphanumeric(number: 7) }
    status { "activated" }
    pac { Faker::Alphanumeric.alphanumeric(number: 7) }
    company_id { Faker::Number.decimal_part(digits: 5) }
    units { { liter: Faker::Number.decimal_part(digits: 5) } }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }

    trait :activated do
      status { "activated" }
    end

    trait :desactivated do
      status { "desactivated" }
    end

    association :valve_transition, factory: :valve_transition
  end
end
