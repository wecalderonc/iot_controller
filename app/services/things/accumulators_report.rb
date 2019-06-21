require 'csv'
module Things
  class AccumulatorsReport
    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo"]

    def self.call(input)
      CSV.generate(headers: true) do |csv|
        csv << HEADERS
        input.each do |device, accumulators|
          accumulators.map do |accumulator| 
            date = accumulator.uplink.created_at.strftime('%a %d %b %Y')
            csv << [device.id, device.name, date, accumulator.value]
          end
        end
      end
    end
  end
end
