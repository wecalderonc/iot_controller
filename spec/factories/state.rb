FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    code_iso { Faker::Address.state_abbr }

    association :country, factory: :country
  end
end
