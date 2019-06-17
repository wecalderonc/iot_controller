FactoryBot.define do
  factory :aqueduct do
    name  { Faker::TvShows::Simpsons.character }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
  end
end
