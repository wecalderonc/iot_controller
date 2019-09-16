FactoryBot.define do
  factory :valve_transition do
    real_state { :not_detected }
    showed_state { :not_detected }
  end
end
