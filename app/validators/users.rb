module Validators::Users
  CreateSchema = Dry::Validation.Schema do
    required(:first_name).filled(type?: String)
    required(:last_name).filled(type?: String)
    required(:password).value(type?: String)
    required(:email).filled(type?: String, format?: User::VALID_EMAIL)
    required(:phone).value(type?: String)
    required(:gender).value(type?: Symbol, included_in?: User::GENDERS)
    required(:id_number).value(type?: String)
    required(:id_type).value(type?: Symbol, included_in?: User::ID_TYPES)
    required(:code_number).maybe(type?: String)
    optional(:admin).value(type?: (TrueClass || FalseClass))
    optional(:user_type).value(type?: Symbol, included_in?: User::USER_TYPE)
  end
end
