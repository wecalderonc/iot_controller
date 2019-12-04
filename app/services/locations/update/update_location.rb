require 'dry/transaction'

class Locations::Update::UpdateLocation
  include Dry::Transaction

  def call(input)
    location = input[:thing].locates

    Locations::Update::BaseUpdater.new.(input, location, :location)
    assign_thing(input)
  end

  private

  def assign_thing(input)
    if new_thing_name?(input)
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

  def new_thing_name?(input)
    input.has_key?(:new_thing_name) && input[:new_thing_name] != input[:thing_name]
  end
end
