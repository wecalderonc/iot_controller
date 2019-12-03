require 'dry/transaction'

class Locations::CreateRelations
  include Dry::Transaction

  def call(input)
    thing = input[:thing]

    #byebug
    Owner.create(from_node: input[:user], to_node: thing)
    ThingLocation.create(from_node: thing, to_node: input[:location])
#   thing.update(locates: input[:location])
#   location.update(thing: thing)

    validate_user_location(input)
  end

  def validate_user_location(input)
    if input[:user].locates.exclude?(input[:location])
      UserLocation.create(from_node: input[:user], to_node: input[:location])
    end
  end
end
