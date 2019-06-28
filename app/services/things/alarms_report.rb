# This service returns a string csv
require 'csv'
module Things
  class AlarmsReport

    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Alarma"]

    GetAlarmDate = -> alaram do
      alaram.uplink.created_at.strftime('%a %d %b %Y')
    end

    def self.call(input)
      CSV.generate(headers: true) do |csv|

        csv << HEADERS
        input.each do |device, alarams|
          csv << ["Device name: #{device.name}"]

          alarams.each do |alaram|
            date = GetAlarmDate.(alaram)
            csv << [device.id, device.name, date, alaram.value]
          end
        end
      end
    end
  end
end
