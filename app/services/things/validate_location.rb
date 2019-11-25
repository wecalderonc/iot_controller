require 'dry/transaction/operation'

class Things::ValidateLocation
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]

    if input[:thing].locates.present?
      Failure Errors.service_error("The thing #{input[:thing_name]} is already located in another place", 10104, self.class)
    else
      Success input
    end
  end
end
