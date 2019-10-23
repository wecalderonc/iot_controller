require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::Compare
  include Dry::Transaction::Operation

  def call(input)
    battery_level_date = input[:upward_transition].created_at
    alarm_date = input[:last_power_connection_alarm].created_at
    result = closer(battery_level_date, alarm_date)

    input.merge(start_date: result)
  end

  private

  def closer(battery_level_date, alarm_date)
    battery_level_date < alarm_date ? alarm_date : battery_level_date
  end
end
