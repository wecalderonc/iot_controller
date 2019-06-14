FactoryBot.define do
  factory :thing do
    name { Faker::Lorem.word }
  end
end
