require 'csv'

def create_acc(data, uplink)
  p "Creating Accumulator"

  hex = data[1].to_i(16).to_s.rjust(8, '0')

  p Accumulator.create(value: hex, uplink: uplink)
end

def create_alarm(data, uplink)
  p "Creating Alarms"

  p data[1]
  name = ALARM_CONV[data[1]]
  a = HARDWARE_ALARMS.select { |k,v| v.eql?(name) }
  b = SOFTWARE_ALARMS.select { |k,v| v.eql?(name) }

  p a
  p b

  value = a.keys.first || b.keys.first
  p value

  alarm = Alarm.new(
    value: "000#{value}",
    viewed: false,
    created_at: DateTime.parse(data[0]),
    uplink: uplink
  )

  if alarm.valid?
    alarm.save
    p 'alarm created'

    ala_attrs = {
      name: name,
      created_at: DateTime.parse(data[0]),
      value: value,
      type: a.present? ? :hardware : :software,
      alarm: alarm
    }

    at = AlarmType.new(ala_attrs)

    if at.valid?
      p "at creado"
      p at.save
    else
      p at.errors
    end
  else
    p alarm.errors
  end

end

def create_battery(data, uplink)
  p "Creating Batteries"

  bat_attrs = {
    created_at: DateTime.parse(data[0]),
    value: BATTERY_CONV[data[1]],
    uplink: uplink
  }

  p BatteryLevel.create(bat_attrs)
end

file_number = 1

p "Creating Thing #{file_number}"
  thing = Thing.find_by(name: "MES-0#{file_number}")

  if thing.blank?
    thing = Thing.new(
      name: "MES-0#{file_number}",
      status: "activated",
      pac: "io46eui4oe6uioe1ui6o4",
      company_id: "12",
      latitude: 4,
      longitude: 75,
      valve_transition: ValveTransition.create,
      units: { liter: 1 },
      flow_per_minute: 3.47
    )

    if thing.valid?
      p "thing created"
      thing.save
    else
      p thing.errors
    end
  end

  BATTERY_CONV = {
    'Optimo' => '0004',
    'Medio-Alto' => '0003',
    'Medio-Bajo' => '0002',
    'Descargado' => '0001'
  }

  HARDWARE_ALARMS = {
    1 => :power_connection,
    2 => :induced_site_alarm,
    3 => :sos
  }

  SOFTWARE_ALARMS = {
    1 => :unexpected_dump,
    2 => :impossible_consumption,
    3 => :low_battery,
    4 => :stuck_valve
  }

  ALARM_CONV = {
    'Conexión de Energía' => :power_connection,
    'S.O.S' => :sos,
    'Alarma Inducida en Sitio' => :induced_site_alarm
  }

file = CSV.read("#{Rails.root}/script/MES-0#{file_number}.csv")

p "Creating Uplink #{file_number}"

grouped = file.group_by { |o| o[0] }

p "Creando #{grouped.count} uplinlks"

grouped.each do |date, line|
  p uplink = Uplink.new(
    data: "016774300806702ffff10000",
    avgsnr: "18.47", rssi: "-530.00",
    long: "-74.0",
    lat: "5.0",
    snr: "16.32",
    station: "146A",
    seqnumber: "77",
    time: DateTime.parse(date).to_time.to_i.to_s,
    sec_uplinks: "006",
    sec_downlinks: "0",
    thing: thing
  )

  if uplink.valid?
    uplink.save
    p 'uplink created'
    p "Creando #{line.count} subs"

    line.each do |l|
      if l[2].eql?('b')
        create_battery(l, uplink)
      elsif l[2].eql?('a')
        create_alarm(l, uplink)
      elsif l[2].eql?('acc')
        create_acc(l, uplink)
      end
    end
  else
    p uplink.errors
  end
end
