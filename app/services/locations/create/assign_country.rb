require 'dry/transaction'

class Locations::Create::AssignCountry
  include Dry::Transaction

  FindCountry = -> input do
    Country.find_by(code_iso: input[:country])
  end

  def call(input)
    country = FindCountry.(input[:country_state_city])

    if country.present?
      input[:country_state_city][:country] = country

      Success input
    else
      Failure Errors.general_error("Country not found", self.class)
    end
  end
end
