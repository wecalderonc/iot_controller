require 'dry/transaction'

class Users::UpdateCountry
  include Dry::Transaction

  def call(input)
    country = Country.find_by(code_iso: input[:country_code])

    if country.present?
      input[:user].update(country: country)

      Success input
    else
      Failure Errors.general_error("Country not found", self.class)
    end
  end
end
