module Validators::Users
  CreateSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:first_name).filled(type?: String)
    required(:last_name).filled(type?: String)
    required(:password).value(type?: String)
    required(:email).filled(type?: String, format?: User::VALID_EMAIL)
    required(:country_code).value(type?: String)
    required(:phone).value(type?: String)
    required(:gender).value(type?: Symbol, included_in?: User::GENDERS)
    required(:id_number).value(type?: String)
    required(:id_type).value(type?: Symbol, included_in?: User::ID_TYPES)
    required(:code_number).maybe(type?: String)
    optional(:admin).value(type?: (TrueClass || FalseClass))
    optional(:user_type).value(type?: Symbol, included_in?: User::USER_TYPE)

    validate(uniq_email: :email) do |email|
      User.find_by(email: email).nil?
    end

    validate(uniq_code_number: :code_number) do |code_number|
      User.find_by(code_number: code_number).nil?
    end
  end

  UpdateSchema = Dry::Validation.Schema do
    configure { config.messages_file = "config/locales/en.yml" }

    optional(:first_name).filled(type?: String)
    optional(:last_name).filled(type?: String)
    optional(:new_email).filled(type?: String, format?: User::VALID_EMAIL)
    optional(:country_code).value(type?: String)
    optional(:current_password).value(type?: String)
    optional(:password).value(type?: String)
    optional(:password_confirmation).value(type?: String)

    validate(new_password: %i[current_password password]) do |current_password, password|
      current_password.present? ? password.present? : true
    end

    validate(password_confirmation: %i[password password_confirmation]) do |password, password_confirmation|
      password.present? ? password_confirmation.present? : true
    end

    validate(matched_passwords: %i[password password_confirmation]) do |password, password_confirmation|
      if password.present? && password_confirmation.present?
        password.eql?(password_confirmation)
      else
        true
      end

  RecoverPasswordSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:email).filled?(type?: String)
    required(:current_password).filled(type?: String)
    required(:new_password).filled(type?: String)
    required(:new_password_confirmation).filled(type?: String)

    validate(same_password: %i[new_password new_password_confirmation]) do |new_password, new_password_confirmation|
      new_password.eql?(new_password_confirmation)
    end
  end
end
