require 'dry/transaction'

class Users::Update::Update
  include Dry::Transaction

  step :update_params
  step :update_country

  def update_params(input)
    user = input[:user]

    if user.update(input)
      Success input
    else
      Failure Errors.general_error(user.errors.messages, self.class)
    end
  end

  def update_country(input)
    if input[:country_code].present?
      find_and_update_country(input)
    else
      Success input
    end
  end

  private

  def find_and_update_country(input)
    country = Country.find_by(code_iso: input[:country_code])

    if country.present?
      input[:user].update(country: country)

      Success input
    else
      Failure Errors.general_error("Country not found", self.class)
    end
  end

end
