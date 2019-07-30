# This service returns a string csv
require 'csv'
module Things
  class AccumulatorsReport

    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo", "Delta Acumulado"]

    def self.call(input)
      CSV.generate(headers: true) do |csv|

        csv << HEADERS
        input.each do |device, accumulators|
          csv << ["Device name: #{device.name}"]
          delta = AccumulatorDeltaBuilder.new.(accumulators)

          accumulators.each_with_index do |accumulator, index|
            date = Utils.parse_date(accumulator.uplink.created_at)
            csv << [device.id, device.name, date, accumulator.value, delta[index][:delta], delta[index][:accumulated]]
          end
        end
      end
    end
  end
end
