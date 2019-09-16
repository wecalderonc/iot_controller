require 'dry/transaction'

class Things::Create::CreateThing
  include Dry::Transaction

  def call(input)
    thing = Thing.new(input)

    if thing.save
      create_valve_transition(thing)

      Success thing
    else
      Failure Errors.general_error(thing.errors.messages, self.class)
    end
  end

  private

  def create_valve_transition(thing)
    thing.valve_transition = ValveTransition.create
  end
end
