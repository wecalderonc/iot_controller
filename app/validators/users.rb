module Validators::Users
  CreateSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:first_name).filled(type?: String)
    required(:last_name).filled(type?: String)
    required(:password).value(type?: String)
    required(:email).filled(type?: String, format?: User::VALID_EMAIL)
    required(:country_code).value(type?: String)
    optional(:phone).value(type?: String)
    optional(:gender).value(type?: String)
    optional(:id_number).value(type?: String)
    optional(:id_type).value(type?: String)
    optional(:code_number).maybe(type?: String)
    optional(:admin).value(:bool?)
    optional(:user_type).value(type?: String)

    validate(uniq_email: :email) do |email|
      User.find_by(email: email).nil?
    end

    validate(invalid_gender: :gender) do |gender|
      gender.present? ? User::GENDERS.include?(gender.to_sym) : true
    end

    validate(invalid_id_type: :id_type) do |id_type|
      id_type.present? ? User::ID_TYPES.include?(id_type.to_sym) : true
    end

    validate(invalid_user_type: :user_type) do |user_type|
      user_type.present? ? User::USER_TYPE.include?(user_type.to_sym) : true
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

    validate(wrong_password_confirmation: %i[password password_confirmation]) do |password, password_confirmation|
      password.present? ? password_confirmation.present? : true
    end

    validate(matched_passwords: %i[password password_confirmation]) do |password, password_confirmation|
      if password.present? && password_confirmation.present?
        password.eql?(password_confirmation)
      else
        true
      end
    end
  end

  RecoverPasswordSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:email).filled?(type?: String)
    required(:current_password).filled(type?: String)
    required(:password).filled(type?: String)
    required(:password_confirmation).filled(type?: String)

    validate(same_password: %i[password password_confirmation]) do |new_password, new_password_confirmation|
      new_password.eql?(new_password_confirmation)
    end
  end

  AuthenticateSchema = Dry::Validation.Schema do
    required(:email).filled?(type?: String)
    required(:password).filled(type?: String, format?: User::VALID_PASSWORD)
  end
end
