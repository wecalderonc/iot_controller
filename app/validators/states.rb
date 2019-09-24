module Validators::States
  GetSchema = Dry::Validation.Schema do
    required(:country_code).filled(type?: String)
  end
end
