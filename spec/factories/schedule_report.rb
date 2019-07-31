FactoryBot.define do
  factory :schedule_report do
    email { Faker::Internet.email }
    frequency_day { "monday" }
    frequency_interval { "week" }
    start_date { Faker::Time.between(2.days.ago, Time.now) }
  end
end
