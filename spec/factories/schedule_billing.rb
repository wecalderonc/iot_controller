FactoryBot.define do
  factory :schedule_billing do
    stratum { Faker::Number.between(from: 1, to: 10) }
    basic_charge { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    top_limit { Faker::Number.decimal(l_digits: 2) }
    basic_price { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    extra_price { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    billing_frequency { Faker::Number.between(from: 1, to: 10) }
    billing_period { "month" }
    cut_day { Faker::Number.between(from: 1, to: 10) }
    start_date { Faker::Time.between(2.days.ago, Time.now) }
  end
end
