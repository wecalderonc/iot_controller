FactoryBot.define do
  factory :user do
    first_name  { Faker::TvShows::Simpsons.character }
    last_name  { Faker::TvShows::Simpsons.character }
    email { Faker::Internet.email }
    password { "validpass" }
    password_confirmation { "validpass" }
    phone { Faker::PhoneNumber.cell_phone }
    admin { false }
    gender { :female }
    id_number { Faker::Alphanumeric.alphanumeric 7 }
    id_type { :cc }
    user_type { :aqueduct }
  end
end
