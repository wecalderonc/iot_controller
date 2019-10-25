require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::PowerConnectionAlarm
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    alarms = thing.uplinks.alarm

    result = Alarm.last_power_connection_alarm(alarms)

    if result.present?
      input.merge(last_power_connection_alarm: result)
    else
      input.merge(last_power_connection_alarm: nil)
    end
  end
end
