require 'dry/transaction'

class Locations::AssignCity
  include Dry::Transaction

  FindCity = -> input do
    City.find_by(name: input[:city])
  end

  def call(input)
    city = FindCity.(input[:country_state_city])

    if city.present?
      input[:thing].locates.update(city: city)

      Success input
    else
      Failure Errors.general_error("City not found", self.class)
    end
  end
end
