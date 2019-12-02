require 'dry/transaction'

class Locations::Update::UpdateLocation
  include Dry::Transaction

  def call(input)
    location = input[:thing].locates

    Locations::Update::BaseUpdater.new.(input, location, :location)
    assign_thing(input)
  end

  def assign_thing(input)
    if input.has_key?(:new_thing_name)
      options = {
        true => -> input { remove_relations(input) },
        false => -> input { Locations::Update::AssignThing.new.(input) },
      }[input[:new_thing_name].empty?].(input)
    else
      Success input
    end
  end

  def remove_relations(input)
    input[:thing].update(locates: nil, owner: nil)

    Success input
  end
end
