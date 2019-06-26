# This service returns a string csv
require 'csv'
module Things
  class AlarmsReport

    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Alarma"]

    GetAccumulatorDate = -> accumulator do
      accumulator.uplink.created_at.strftime('%a %d %b %Y')
    end

    def self.call(input)
      CSV.generate(headers: true) do |csv|

        csv << HEADERS
        input.each do |device, accumulators|
          csv << ["Device name: #{device.name}"]

          accumulators.each do |accumulator|
            date = GetAccumulatorDate.(accumulator)
            csv << [device.id, device.name, date, accumulator.value]
          end
        end
      end
    end
  end
end
