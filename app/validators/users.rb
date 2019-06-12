module Validators::Users
  CreateSchema = Dry::Validation.Schema do
    required(:user).schema do
      required(:name).filled(type?: String)
      required(:phone).value(type?: String)
      required(:password).value(type?: String)
      required(:email).filled(type?: String, format?: User::VALID_EMAIL)
    end
  end
end
