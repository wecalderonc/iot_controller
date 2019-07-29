FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    code_iso { Faker::Address.country_code }
  end
end
