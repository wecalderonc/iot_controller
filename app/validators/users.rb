module Validators::Users
  CreateSchema = Dry::Validation.Schema do
    required(:user).schema do
      required(:first_name).filled(type?: String)
      required(:password).value(type?: String)
      required(:email).filled(type?: String, format?: User::VALID_EMAIL)
    end
  end
end
