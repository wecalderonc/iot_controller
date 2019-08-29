require 'dry/transaction'

class Locations::Update::ValidateThing
  include Dry::Transaction

  def call(input)
    if input.has_key?(:new_thing_name)
      assign_thing_name(input)
    else
      Success input
    end
  end

  private

  def assign_thing_name(input)
    if input[:new_thing_name].empty?
      input[:thing].locates.update(thing: nil)

      Success input
    else
      assign_new_thing(input)
    end
  end

  def assign_new_thing(input)
    thing_result = Things::Get.new.({thing_name: input[:new_thing_name]})

    if thing_result.success
      input[:thing].locates.update(thing: thing_result.success[:thing])

      Success input
    else
      thing_result
    end
  end
end
