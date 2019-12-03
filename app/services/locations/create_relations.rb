require 'dry/transaction'

class Locations::CreateRelations
  include Dry::Transaction

  def call(input)
    thing, location, user = input.values_at(:thing, :location, :user)

    Owner.create(from_node: user, to_node: thing)
    location.thing = nil
    ThingLocation.create(from_node: thing, to_node: location)

    validate_user_location(thing, location, user)
  end

  def validate_user_location(thing, location, user)
    if user.locates.exclude?(user)
      UserLocation.create(from_node: user, to_node: location)
    end
  end
end
