require 'dry/transaction/operation'

class Reports::Alarms::JsonReport
  include Dry::Transaction::Operation

  def call(input)
    response = []

    input.each do |device, accumulators|
      proccesed_alarms = []

      accumulators.each_with_index do |accumulator, index|
        date = Utils.parse_date(accumulator.uplink.created_at)

        proccesed_alarms << {
          date: date,
          value: accumulator.value,
        }
      end

      response << {
        thing_id: device.id,
        thing_name: device.name,
        alarms: proccesed_alarms
      }
    end

    response
  end
end
