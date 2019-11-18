#ERASE ALL NODES

p "Erasing Things"
Thing.destroy_all
p "Erasing Uplinks"
Uplink.destroy_all
p "Erasing Users"
User.destroy_all
p "Erasing Accumulators"
Accumulator.destroy_all
p "Erasing Alarms"
Alarm.destroy_all
p "Erasing AlarmType"
AlarmType.destroy_all
p "Erasing Aqueducts"
Aqueduct.destroy_all
p "Erasing BatteryLevels"
BatteryLevel.destroy_all
p "Erasing Sensors"
Sensor1.destroy_all
Sensor2.destroy_all
Sensor3.destroy_all
Sensor4.destroy_all
p "Erasing TimeUplink"
TimeUplink.destroy_all
p "Erasing UplinkBDownlink"
UplinkBDownlink.destroy_all
p "Erasing ValvePosition"
ValvePosition.destroy_all
p "Erasing ValveTransition"
ValveTransition.destroy_all
p "Erasing ScheduleBilling"
ScheduleBilling.destroy_all
p "Erasing ScheduleReport"
ScheduleReport.destroy_all
p "Erasing Locations"
Location.destroy_all
p "Erasing Prices"
Price.destroy_all

p "****************"
p "                "
p "CREATING USERS"
p "                "
p "****************"
p user1 = User.create(first_name:"javier", last_name: "varon", phone: "31261258231",
            gender: "male", id_number: "1645634", user_type: "amigo", id_type: "1",
            email: "jvaron@procibernetica.com", password: "Javier123*" )

p user2 = User.create(first_name:"william", last_name: "calderon", phone: "3013632461",
            gender: "male", id_number: "123456", user_type: "amigo", id_type: "1",
            email: "wcalderon@procibernetica.com", password: "William123*" )

p user3 = User.create(first_name:"daniela", last_name: "patino", phone: "3123204312",
            gender: "male", id_number: "364553", user_type: "amigo", id_type: "2",
            email: "dpatino@procibernetica.com", password: "Dani123*" )

p "****************"
p "                "
p "CREATING THINGS"
p "                "
p "****************"

p thing1 = Thing.create(
  name: "thing_one",
  status: "activated",
  pac: "io46eui4oe6uioe1ui6o4",
  company_id: "12",
  latitude: 4,
  longitude: 75,
  valve_transition: ValveTransition.create,
  units: { liter: 200 },
  flow_per_minute: 50
  )

p thing2 = Thing.create(name: "thing_two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20", latitude: 4, longitude: 75, valve_transition: ValveTransition.create, units: { liter: 200 }, flow_per_minute: 50 )
p thing3 = Thing.create(name: "thing_three", status: "desactivated", pac: "fdsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create, units: { liter: 200 }, flow_per_minute: 50 )
p thing4 = Thing.create(name: "thing_four", status: "desactivated", pac: "gcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create, units: { liter: 200 }, flow_per_minute: 50 )
p thing5 = Thing.create(name: "thing_five", status: "desactivated", pac: "hcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create(showed_state: :open), units: { liter: 200 }, flow_per_minute: 50 )
p thing6 = Thing.create(name: "thing_six", status: "desactivated", pac: "hcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create(showed_state: :opening), units: { liter: 200 }, flow_per_minute: 50 )
p thing7 = Thing.create(name: "thing_seven", status: "desactivated", pac: "hcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create(showed_state: :closing), units: { liter: 200 }, flow_per_minute: 50 )
p thing8 = Thing.create(name: "thing_eight", status: "desactivated", pac: "hcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create(showed_state: :closed), units: { liter: 200 }, flow_per_minute: 50 )

p "****************"
p "                "
p "CREATING PRICE"
p "                "
p "****************"

p Price.create(currency: 'COP', date: Date.today, unit: 'liter', value: 3000)

p "****************"
p "                "
p "CREATING RELATIONS BETWEEN USERS AND THINGS"
p "                "
p "****************"

p Owner.create(from_node:user1, to_node:thing1)
p Owner.create(from_node:user2, to_node:thing2)
p Owner.create(from_node:user3, to_node:thing3)
p Owner.create(from_node:user1, to_node:thing4)
p Owner.create(from_node:user1, to_node:thing5)

p "****************"
p "                "
p "CREATING UPLINKS FOR EVERY THING"
p "                "
p "****************"

p uplink1 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,2))

p uplink12 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,3))

p uplink13 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,4))

p uplink14 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,13))

p uplink2 = Uplink.create(data: "026774300806702ffff10040", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing2)

p uplink3 = Uplink.create(data: "035647200806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing3)

p uplink4 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 1.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,12))

p uplink5 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1570316848", sec_uplinks: "006", sec_downlinks: "0", thing: thing4)

p uplink6 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,7))

p uplink7 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing5)

p uplink8 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: (Date.today - 2.days).to_time.to_i.to_s, sec_uplinks: "006",
              sec_downlinks: "0", thing: thing1, created_at: DateTime.new(2019,11,8))

p "****************"
p "                "
p "CREATING ACCUMULATORS"
p "                "
p "****************"
p accumulator1 = Accumulator.create(value: "00000001", uplink: uplink1, created_at: DateTime.new(2019,11,2))
p accumulator12 = Accumulator.create(value: "00000010", uplink: uplink12, created_at: DateTime.new(2019,11,3))
p accumulator13 = Accumulator.create(value: "00000020", uplink: uplink13, created_at: DateTime.new(2019,11,4))
p accumulator14 = Accumulator.create(value: "00000030", uplink: uplink14, created_at: DateTime.new(2019,11,5))
p accumulator2 = Accumulator.create(value: "0002", uplink: uplink2)
p accumulator3 = Accumulator.create(value: "0003", uplink: uplink3)
p accumulator4 = Accumulator.create(value: "00000040", uplink: uplink4, created_at: DateTime.new(2019,11,6))
p accumulator5 = Accumulator.create(value: "0005", uplink: uplink5)
p accumulator6 = Accumulator.create(value: "00000050", uplink: uplink6, created_at: DateTime.new(2019,11,7))
p accumulator7 = Accumulator.create(value: "0000aff0", uplink: uplink7)
p accumulator8 = Accumulator.create(value: "00000060", uplink: uplink8, created_at: DateTime.new(2019,11,8))

p "****************"
p "                "
p "CREATING ALARMS"
p "                "
p "****************"

p alarm1 = Alarm.create(value: "0001", viewed: true, uplink: uplink1, created_at: DateTime.new(2019,01,01))
p alarm12 = Alarm.create(value: "0002", viewed: false, uplink: uplink12, created_at: DateTime.new(2019,01,01))
p alarm13 = Alarm.create(value: "0003", viewed: false, uplink: uplink13, created_at: DateTime.new(2019,01,01))
p alarm14 = Alarm.create(value: "0001", viewed: false, uplink: uplink14, created_at: DateTime.new(2019,01,01))
p alarm_type1 = AlarmType.create(name: "power_connection", value: 1, type: "hardware", alarm: alarm1)
p alarm_type12 = AlarmType.create(name: "induced_site_alarm", value: 1, type: "hardware", alarm: alarm12)
p alarm_type13 = AlarmType.create(name: "sos", value: 3, type: "hardware", alarm: alarm13)
p alarm_type14 = AlarmType.create(name: "power_connection", value: 1, type: "hardware", alarm: alarm14)
p alarm2 = Alarm.create(value: "0002", viewed: false, uplink: uplink2)
p alarm3 = Alarm.create(value: "0003", viewed: false, uplink: uplink3)
p alarm4 = Alarm.create(value: "0004", viewed: true, uplink: uplink4)
p alarm6 = Alarm.create(value: "0006", viewed: false, uplink: uplink6)
p alarm7 = Alarm.create(value: "0003", viewed: false, uplink: uplink7)
p alarm_type71 = AlarmType.create(name: "sos", value: 3, type: "hardware", alarm: alarm7)
p alarm8 = Alarm.create(value: "0007", viewed: false, uplink: uplink8)

p "****************"
p "                "
p "CREATING ALARMS"
p "                "
p "****************"

p alarm_type1 = AlarmType.create(name: :power_connection, value: "0001", type: :hardware, alarm: alarm1)
p alarm_type4 = AlarmType.create(name: :unexpected_dump, value: "0004", type: :software, alarm: alarm4)
p alarm_type6 = AlarmType.create(name: :induced_site_alarm, value: "0006", type: :hardware, alarm: alarm6)
p alarm_type8 = AlarmType.create(name: :low_battery, value: "0008", type: :software, alarm: alarm8)

p "****************"
p "                "
p "CREATING THING_ONE BATTERYLEVELS"
p "                "
p "****************"

p uplink101 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink102 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink103 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink104 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink105 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink106 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink107 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink108 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink109 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p uplink110 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00", long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77", time: (Date.today - 2.months - 2.days).to_time.to_i.to_s, sec_uplinks: "006", sec_downlinks: "0", thing: thing1)
p BatteryLevel.create(value: "0004", uplink: uplink101, created_at: DateTime.new(2019,10,1))
p BatteryLevel.create(value: "0004", uplink: uplink102, created_at: DateTime.new(2019,10,2))
p BatteryLevel.create(value: "0003", uplink: uplink103, created_at: DateTime.new(2019,10,3))
p BatteryLevel.create(value: "0003", uplink: uplink104, created_at: DateTime.new(2019,10,4))
p BatteryLevel.create(value: "0002", uplink: uplink105, created_at: DateTime.new(2019,10,5))
p BatteryLevel.create(value: "0002", uplink: uplink106, created_at: DateTime.new(2019,10,6))
p BatteryLevel.create(value: "0001", uplink: uplink107, created_at: DateTime.new(2019,10,7))
p BatteryLevel.create(value: "0001", uplink: uplink108, created_at: DateTime.new(2019,10,8))
p BatteryLevel.create(value: "0001", uplink: uplink109, created_at: DateTime.new(2019,10,9))
p BatteryLevel.create(value: "0001", uplink: uplink110, created_at: DateTime.new(2019,10,10))

p "****************"
p "                "
p "CREATING GENERAL BATTERYLEVELS"
p "                "
p "****************"

p BatteryLevel.create(value: "0002", uplink: uplink2)
p BatteryLevel.create(value: "0003", uplink: uplink3)
p BatteryLevel.create(value: "0005", uplink: uplink5)
p BatteryLevel.create(value: "0004", uplink: uplink7)

p "****************"
p "                "
p "CREATING LOCATIONS WITH REPORTS"
p "                "
p "****************"
p billing = ScheduleBilling.create(stratum: 3, billing_period: 'month', start_date: Date.today - (3.months + 8.days), basic_charge_price: 13.841, basic_price: 2.100, extra_price: 1.100)
p report = ScheduleReport.create(email: "ivillamor@procibernetica.com", start_date: Date.today)

p city = City.find_by(name: 'Bogota')
p city.state

p location1 = Location.create(name: "apartamento", address: "Carrera 7 # 71 -21", latitude: 4.1, longitude: 74.1, thing: thing1, schedule_billing: billing, schedule_report: report, city: city)
p location2 = Location.create(name: 'casa', address: "Carrera 68D # 39 - 46", latitude:  5.1, longitude: 75.1, thing: thing2, schedule_billing: billing, schedule_report: report, city: city)
p location3 = Location.create(name: 'negocio', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing3, schedule_billing: billing, schedule_report: report, city: city)
p location4 = Location.create(name: 'negocio2', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing4, schedule_billing: billing, schedule_report: report, city: city)
p location5 = Location.create(name: 'negocio3', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing5, schedule_billing: billing, schedule_report: report, city: city)
p location6 = Location.create(name: 'negocio4', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing6, schedule_billing: billing, schedule_report: report, city: city)
p location7 = Location.create(name: 'negocio5', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing7, schedule_billing: billing, schedule_report: report, city: city)


p "****************"
p "                "
p "CREATING RELATIONS BETWEEN USERS AND LOCATIONS"
p "                "
p "****************"

p UserLocation.create(from_node:user1, to_node: location1)
p UserLocation.create(from_node:user2, to_node: location2)
p UserLocation.create(from_node:user3, to_node: location3)
p UserLocation.create(from_node:user1, to_node: location4)
p UserLocation.create(from_node:user1, to_node: location5)
# p UserLocation.create(from_node:user1, to_node: location6)
# p UserLocation.create(from_node:user1, to_node: location7)
