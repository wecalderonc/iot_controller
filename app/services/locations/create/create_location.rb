require 'dry/transaction'

class Locations::Create::CreateLocation
  include Dry::Transaction

  def call(input)
    location = Location.new(input[:location])

    if location.save
      input[:location] = location
      Locations::CreateRelations.new.(input)

      Success input
    else
      Failure Errors.general_error(location.errors.messages, self.class)
    end
  end
end
