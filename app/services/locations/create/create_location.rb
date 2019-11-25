require 'dry/transaction'

class Locations::Create::CreateLocation
  include Dry::Transaction

  def call(input)
    location = Location.new(input[:location])

    if location.save
      input[:location] = location
      create_relationships(input)

      Success input
    else
      Failure Errors.general_error(location.errors.messages, self.class)
    end
  end

  private

  def create_relationships(input)
    Owner.create(from_node: input[:user], to_node: input[:thing])
    input[:thing].update(locates: input[:location])
    UserLocation.create(from_node: input[:user], to_node: input[:location])
  end
end
