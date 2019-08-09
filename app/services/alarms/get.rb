require 'dry/transaction/operation'

class Alarms::Get
  include Dry::Transaction::Operation

  def call(input)
    alarm = Alarm.find_by(id: input[:alarm_id])

    if alarm.present?
      Success input.merge(alarm: alarm)
    else
      Failure Errors.general_error("The alarm #{input[:alarm_id]} does not exist", self.class)
    end
  end
end
