require 'dry/transaction'

class Locations::Create::CreateLocation
  include Dry::Transaction

  def call(input)
    location = Location.new(input[:location])

    if location.save
      input[:location] = location
      create_relationship(input)

      Success input
    else
      Failure Errors.general_error(location.errors.messages, self.class)
    end
  end

  private

  def create_relationship(input)
    ThingLocation.create!(from_node: input[:thing], to_node: input[:location])
  end
end
