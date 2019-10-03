require 'dry/transaction/operation'
require 'csv'

class Reports::Accumulators::CsvReport
  include Dry::Transaction::Operation

  HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo", "Delta Acumulado"]

  def call(input)
    CSV.generate(headers: true) do |csv|

      csv << HEADERS
      input[:objects].each do |device, accumulators|
        csv << ["Device name: #{device.name}"]

        deltas = AccumulatorDeltaBuilder.new.(accumulators)

        accumulators.each_with_index do |accumulator, index|
          date = Utils.parse_date(accumulator.uplink.created_at)

          csv << [device.id, device.name, date, accumulator.value, deltas[index][:delta], deltas[index][:accumulated]]
        end
      end
    end
  end
end
