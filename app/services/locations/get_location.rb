require 'dry/transaction/operation'

class Locations::GetLocation
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    location = thing.locates

    if location.present?
      Success location
    else
      Failure Errors.general_error("The thing #{input[:thing_name]} does not have location", self.class)
    end
  end
end
