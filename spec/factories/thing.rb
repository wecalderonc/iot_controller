FactoryBot.define do
  factory :thing do
    name { Faker::Lorem.word }
    status { "activated" }
    pac { Faker::Alphanumeric.alphanumeric 7 }
    company_id { Faker::Number.decimal_part(5) }
    coordinates { [ Faker::Address.longitude, Faker::Address.latitude ] }

    trait :activated do
      status { "activated" }
    end

    trait :desactivated do
      status { "desactivated" }
    end
  end
end
