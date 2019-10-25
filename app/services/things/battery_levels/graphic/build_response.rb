require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    start_date = input[:start_date]
    battery_levels = input[:batteries]

    if start_date.present?
      input[:thing].battery_level_query(start_date)
    else
      BatteryLevel.sort_battery_levels(battery_levels)
    end
  end
end
