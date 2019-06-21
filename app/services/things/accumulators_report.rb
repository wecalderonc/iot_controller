require 'csv'
module Things
  class AccumulatorsReport

    def self.call(input)
      headers = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo"]
      CSV.generate(headers: true) do |csv|
        csv << headers
     
        input.each do |device, accumulators|
          accumulators.map do |accumulator| 
            csv << [device.id, device.name, accumulator.uplink.time, accumulator.value]
          end
        end
      end
    end
  end
end
