require 'dry/transaction/operation'

class Reports::Accumulators::JsonReport
  include Dry::Transaction::Operation

  def call(input)
    response = []

    input.each do |device, accumulators|
      deltas = AccumulatorDeltaBuilder.new.(accumulators)

      proccesed_acc = []

      accumulators.each_with_index do |accumulator, index|
        date = Utils.parse_date(accumulator.uplink.created_at)
        proccesed_acc << {
          date: date,
          value: accumulator.value,
          consumption_delta: deltas[index][:delta],
          accumulated_delta: deltas[index][:accumulated]
        }
      end

      response << {
        thing_id: device.id,
        thing_name: device.name,
        accumulators: proccesed_acc
      }
    end

    response
  end
end
