module Validators::Cities
  GetSchema = Dry::Validation.Schema do
    required(:state_code).filled(type?: String)
  end
end
