module Validators::Users
  CreateSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

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

    validate(uniq_email: :email) do |email|
      !User.exists?(email: email)
    end

    validate(uniq_code_number: :code_number) do |code_number|
      !User.exists?(code_number: code_number)
    end
  end
end
