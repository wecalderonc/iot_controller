FactoryBot.define do
  factory :user do
    first_name  { Faker::TvShows::Simpsons.character }
    last_name  { Faker::TvShows::Simpsons.character }
    #TODO fix email with dot(daniela.patino) have problem with the routes in the path
    email { Faker::Internet.email(separators: %w(_ -)) }
    password { Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true) } #=> "*%NkOnJsH4"
    password_confirmation { "validpass" }
    admin { false }
    phone { Faker::PhoneNumber.cell_phone }
    gender { :female }
    id_number { Faker::Alphanumeric.alphanumeric(number: 7) }
    id_type { :cc }
    code_number { Faker::Alphanumeric.alphanumeric(number: 7) }
    user_type { :aqueduct }
    verificated { false }
    verification_code { nil }
  end
end
