FactoryBot.define do
  factory :user do
    name  { Faker::TvShows::Simpsons.character }
    email { Faker::Internet.email }
    password { "validpass" }
    password_confirmation { "validpass" }
  end
end
