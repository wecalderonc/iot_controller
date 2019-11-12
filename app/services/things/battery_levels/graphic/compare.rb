require 'dry/transaction/operation'
require 'dry/monads'

class Things::BatteryLevels::Graphic::Compare
  include Dry::Monads[:maybe]
  include Dry::Transaction::Operation

  def call(input)
    alarm = input[:last_power_connection_alarm]
    battery_level = input[:upward_transition]

    start_date = Maybe(alarm).and(Maybe(battery_level))
      .bind { |alarm, battery_level| nearest_date(alarm, battery_level) }
      .or(Maybe(alarm).bind { |alarm| alarm_date(alarm) })
      .or(Maybe(battery_level).bind { |battery_level| battery_level_date(battery_level) })
      .value_or { {} }

    input.merge(start_date: start_date)
  end

  private

  def date_comparison(battery_level_date, alarm_date)
    battery_level_date < alarm_date ? alarm_date : battery_level_date
  end

  def alarm_date(alarm)
    Some(alarm.created_at)
  end

  def battery_level_date(battery_level)
    Some(battery_level.created_at)
  end

  def nearest_date(alarm, battery_level)
    battery_level_date = battery_level.created_at
    alarm_date = alarm.created_at

    result = date_comparison(battery_level_date, alarm_date)

    Some(result)
  end
end
