require 'dry/transaction/operation'
require 'dry/monads'

class Things::BatteryLevels::Graphic::Compare
  include Dry::Monads[:maybe]
  include Dry::Transaction::Operation

  alarm_date = -> input {
    Maybe(alarm.created_at)
  }

  battery_level_date = -> input {
    Maybe(battery_level.created_at)
  }

  nearest_date = -> input {
    battery_level_date = battery_level.created_at
    alarm_date = alarm.created_at

    result = date_comparison(battery_level_date, alarm_date)

    Maybe(result)
  }

  def call(input)
    alarm = input[:last_power_connection_alarm]
    battery_level = input[:upward_transition]

    start_date = Maybe(alarm).and(Maybe(battery_level))
      .bind(nearest_date)
      .or(Maybe(alarm).bind(alarm_date))
      .or(Maybe(battery_level).bind(battery_level_date))
      .value_or { {} }

    input.merge(start_date: start_date)
  end

  private

  def date_comparison(battery_level_date, alarm_date)
    battery_level_date < alarm_date ? alarm_date : battery_level_date
  end
end
