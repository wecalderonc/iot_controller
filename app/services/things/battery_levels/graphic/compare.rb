require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::Compare
  include Dry::Transaction::Operation

  def call(input)
    if input[:last_power_connection_alarm].present? && input[:upward_transition].present?
      battery_level_date = input[:upward_transition].created_at
      alarm_date = input[:last_power_connection_alarm].created_at
      result = closer(battery_level_date, alarm_date)

      input.merge(start_date: result)
    elsif input[:last_power_connection_alarm].present?
      input.merge(start_date: input[:last_power_connection_alarm].created_at)
    elsif input[:upward_transition].present?
      input.merge(start_date: input[:upward_transition].created_at)
    else
      input.merge(start_date: {})
    end

  end

  private

  def closer(battery_level_date, alarm_date)
    battery_level_date < alarm_date ? alarm_date : battery_level_date
  end
end
