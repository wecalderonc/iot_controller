FactoryBot.define do
  factory :price do
    value    { 1000 }
    unit     { :liter }
    date     { Date.today }
    currency { 'COP' }
  end
end
