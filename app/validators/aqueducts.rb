module Validators::Aqueducts
  CreateSchema = Dry::Validation.Schema do
    required(:aqueduct).schema do
      required(:name).filled(type?: String)
      required(:email).filled(type?: String)
      required(:phone).filled(type?: String, format?: Aqueduct::VALID_PHONE)
    end
  end
end
