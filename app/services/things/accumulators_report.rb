# This service returns a string csv
require 'csv'
module Things
  class AccumulatorsReport

    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo", "Delta Acumulador"]

    def call(input)
      CSV.generate(headers: true) do |csv|

        csv << HEADERS
        input.each do |device, accumulators|
          csv << ["Device name: #{device.name}"]
          delta = AccumulatorDeltaBuilder.new.(accumulators)
          accumulators.map.with_index do |accumulator, index|
            date = accumulator.uplink.created_at.strftime('%a %d %b %Y')
            csv << [device.id, device.name, date, accumulator.value, delta[index][:delta], delta[index][:accumulated]]
          end
        end
      end
    end
  end
end
