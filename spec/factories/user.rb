FactoryBot.define do
  factory :user do
    first_name  { Faker::TvShows::Simpsons.character }
    last_name  { Faker::TvShows::Simpsons.character }
    #TODO fix email with dot(daniela.patino) have problem with the routes in the path
    email { Faker::Internet.email(separators: %w(_ -)) }
    password { Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true) } #=> "*%NkOnJsH4"
    password_confirmation { "validpass" }
    phone { Faker::PhoneNumber.cell_phone }
    admin { false }
    gender { :female }
    id_number { Faker::Alphanumeric.alphanumeric(number: 7) }
    id_type { :cc }
    user_type { :aqueduct }
#   verification_code { Faker::Alphanumeric.alphanumeric(number: 6) }
    verification_code { SecureRandom.hex(6) }
  end
end
