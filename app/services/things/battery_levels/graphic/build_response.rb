require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    start_date = input[:start_date]

    if start_date.present?
      input[:thing].battery_level_query(start_date)
    else
      input[:thing].uplinks.batteryLevel.order(:created_at)
    end
  end
end
