require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::PowerConnectionAlarm
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    alarms = thing.uplinks.alarm

    last_power_connection_alarm = last_power_connection_alarm(alarms)

    if last_power_connection_alarm.present?
      input.merge(last_power_connection_alarm: last_power_connection_alarm)
    else
      input.merge(last_power_connection_alarm: {})
    end
  end

  private

  def last_power_connection_alarm(alarms)
    alarms.where(value:"0001").order(:created_at).last
  end
end
