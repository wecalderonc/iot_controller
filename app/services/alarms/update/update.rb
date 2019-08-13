require 'dry/transaction/operation'

class Alarms::Update::Update
  include Dry::Transaction::Operation

  def call(input)
    alarm = input[:alarm]

    if alarm.update(input[:params])
      Success input
    else
      Failure Errors.general_error(alarm.errors.messages, self.class)
    end
  end
end
