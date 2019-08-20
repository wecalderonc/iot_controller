module Validators::BatteryLevels
  GetSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
  end
end
