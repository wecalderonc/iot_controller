require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::Compare
  include Dry::Transaction::Operation

  def call(input)
    if input[:last_power_connection_alarm].present? && input[:upward_transition].present?
      battery_level_date = input[:upward_transition].created_at
      alarm_date = input[:last_power_connection_alarm].created_at

      result = nearest_date(battery_level_date, alarm_date)

      input.merge(start_date: result)
    elsif input[:last_power_connection_alarm].present?
      input.merge(start_date: input[:last_power_connection_alarm].created_at)
    elsif input[:upward_transition].present?
      input.merge(start_date: input[:upward_transition].created_at)
    else
      input.merge(start_date: {})
    end


    options = {
      true:
      false: {
        true: {},
        false: {}
      }
    }

    options.default =

    define = input[:last_power_connection_alarm].present? && input[:upward_transition].present?
    options[define]
  end

  private

  def nearest_date(battery_level_date, alarm_date)
    battery_level_date < alarm_date ? alarm_date : battery_level_date
  end
end
