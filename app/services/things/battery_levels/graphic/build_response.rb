require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    start_date = input[:start_date]

    if start_date.present?
      input[:thing].uplinks.batteryLevel(:n)
        .where("n.created_at > {date}")
        .params(date:start_date.to_i)
        .order(:created_at)
    else
      input[:thing].uplinks.batteryLevel.order(:created_at)
    end
  end
end
