FactoryBot.define do
  factory :valve_state do
    state { :not_detected }

    association :thing, factory: :thing
  end
end
