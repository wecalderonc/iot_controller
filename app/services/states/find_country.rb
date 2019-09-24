require 'dry/transaction/operation'

class States::FindCountry
  include Dry::Transaction::Operation

  def call(input)
    country = Country.find_by(code_iso: input[:country_code])

    if country.present?
      Success input.merge(country: country)
    else
      Failure Errors.service_error("Country not found", 10104, self.class)
    end
  end
end
