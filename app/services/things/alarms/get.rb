require 'dry/transaction/operation'

class Things::Alarms::Get
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing_id]
    alarms = thing.uplinks.alarm

    if alarms.present?
      Success input.merge(alarms: alarms)
    else
      Failure Errors.general_error("The thing #{input[:thing_id]} does not have alarms", self.class)
    end
  end
end
