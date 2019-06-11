FactoryBot.define do
  factory :thing do
    title { Faker::Lorem.word }
  end
end
