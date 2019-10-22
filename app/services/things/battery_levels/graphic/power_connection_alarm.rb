require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::PowerConnectionAlarm
  include Dry::Transaction::Operation

  def call(input)
    alarms = input[:alarms]
    last_power_connection_alarm = last_power_connection_alarm(alarms)

    if last_power_connection_alarm.present?
      Success input.merge(last_power_connection_alarm: last_power_connection_alarm)
    else
      Failure Errors.general_error("The thing #{input[:thing_name]} does not have a power_connection alarm", self.class)
    end
  end

  private

  def last_power_connection_alarm(alarms)
    alarms.where(value:"0001").order(:created_at).last
  end
end
