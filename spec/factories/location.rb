FactoryBot.define do
  factory :location do
    name { Faker::Name.name }
    address { Faker::Address.full_address }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }

    association :city, factory: :city
    association :schedule_report, factory: :schedule_report
    association :schedule_billing, factory: :schedule_billing

    trait :with_thing do
      association :thing, factory: :thing
    end

    trait :with_user do
      association :user, factory: :user
    end
  end
end
