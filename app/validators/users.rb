module Validators::Users
  CreateSchema = Dry::Validation.Schema do
    required(:user).schema do
      required(:first_name).filled(type?: String)
      required(:last_name).filled(type?: String)
      required(:password).value(type?: String)
      required(:email).filled(type?: String, format?: User::VALID_EMAIL)
      required(:admin).value(type?: (TrueClass || FalseClass))
      required(:phone).value(type?: String)
      required(:gender).value(type?: Symbol, included_in?: User::GENDERS)
      required(:id_number).value(type?: String)
      required(:id_type).value(type?: Symbol, included_in?: User::ID_TYPES)
      optional(:code_number).maybe(type?: String)
      required(:user_type).value(type?: Symbol, included_in?: User::USER_TYPE)
    end
  end
end
