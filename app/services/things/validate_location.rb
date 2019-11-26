require 'dry/transaction/operation'

class Things::ValidateLocation
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]

    if input[:thing].locates.present?
      Failure Errors.general_error("The thing #{input[:thing_name]} is already located in another place", self.class)
    else
      Success input
    end
  end
end
