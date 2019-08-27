require 'dry/transaction'

class Locations::Update::Schedule
  include Dry::Transaction

  def call(input, model)
    schedule = input[:thing].locates.send(model)

    if schedule.update(input[model])
      Success input
    else
      Failure Errors.general_error(schedule.errors.messages, self.class)
    end
  end
end
