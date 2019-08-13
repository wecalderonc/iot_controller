require 'dry/transaction/operation'

class Alarms::Get
  include Dry::Transaction::Operation

  def call(input)
    id = input[:alarm_id]
    alarm = Alarm.find_by(id: id)

    if alarm.present?
      Success input.merge(alarm: alarm)
    else
      Failure Errors.general_error("The alarm #{id} does not exist", self.class)
    end
  end
end
