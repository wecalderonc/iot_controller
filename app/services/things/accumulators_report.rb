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
          deltas = AccumulatorDeltaBuilder.new.(accumulators)

          accumulators.each_with_index do |accumulator, index|
            date = Utils.parse_date(accumulator.uplink.created_at)

            csv << [device.id, device.name, date, accumulator.value, deltas[index][:delta], deltas[index][:accumulated]]
          end
        end
      end
    end

    def report_json(input)
      puts "input -> #{input.inspect}"
      input.each do |device, accumulators|
        deltas = AccumulatorDeltaBuilder.new.(accumulators)
        puts "*" * 100
        puts deltas.inspect
        puts "*" * 100

        hash = {}

        accumulators.each_with_index do |accumulator, index|
          date = Utils.parse_date(accumulator.uplink.created_at)
          hash = {"thing_id" => device.id, }
          hash.merge({
            "thing_id" => device.id,
            "thing_name" => device.name,
            "date" => date,
            "value" => accumulator.value,
            "consumption_delta" => deltas[index][:delta],
            "accumulated_delta" => deltas[index][:accumulated]
          })
        end
        puts "." * 100
        puts hash.inspect
        puts "." * 100
        hash
      end
    end
  end
end
