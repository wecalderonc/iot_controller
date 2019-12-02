require 'dry/transaction'

class Locations::CreateRelations
  include Dry::Transaction

  def call(input)
    thing = input[:thing]

    Owner.create(from_node: input[:user], to_node: thing)
    thing.update(locates: input[:location])

    validate_user_location(input)
  end

  def validate_user_location(input)
    if input[:user].locates.exclude?(input[:location])
      UserLocation.create(from_node: input[:user], to_node: input[:location])
    end
  end
end
