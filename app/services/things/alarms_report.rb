# This service returns a string csv
require 'csv'
module Things
  class AlarmsReport

    HEADERS = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Alarma"]

    def self.call(input)
      CSV.generate(headers: true) do |csv|

        csv << HEADERS
        input.each do |device, alarms|
          csv << ["Device name: #{device.name}"]

          alarms.each do |alarm|
#           date = ThingsUtils::GetUplinkDate.(alarm)
            date = Utils.parse_date(alarm.uplink.created_at)
            csv << [device.id, device.name, date, alarm.value]
          end
        end
      end
    end
  end
end
