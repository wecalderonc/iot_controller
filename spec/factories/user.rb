FactoryBot.define do
  factory :user do
    email  { "valid@mail.co" }
    password { "validpass" }
    password_confirmation { "validpass" }
  end
end
