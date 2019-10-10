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
  units: { liter: 200 }
  )

p thing2 = Thing.create(name: "thing_two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20", latitude: 4, longitude: 75, valve_transition: ValveTransition.create)
p thing3 = Thing.create(name: "thing_three", status: "desactivated", pac: "fdsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create)
p thing4 = Thing.create(name: "thing_four", status: "desactivated", pac: "gcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create)
p thing5 = Thing.create(name: "thing_five", status: "desactivated", pac: "hcsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75, valve_transition: ValveTransition.create)

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

p Owner.create(from_node: user1, to_node: thing1)
p Owner.create(from_node:user2, to_node:thing2)
p Owner.create(from_node:user3, to_node:thing3)
p Owner.create(from_node:user1, to_node:thing4)
p Owner.create(from_node:user1, to_node:thing5)

p "****************"
p "                "
p "CREATING UPLINKS FOR EVERY THING"
p "                "
p "****************"

uplink1 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing1)

uplink2 = Uplink.create(data: "026774300806702ffff10040", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing2)

uplink3 = Uplink.create(data: "035647200806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing3)

uplink4 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1569989028", sec_uplinks: "006", sec_downlinks: "0", thing: thing1)

uplink5 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1570316848", sec_uplinks: "006", sec_downlinks: "0", thing: thing4)

uplink6 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1570403248", sec_uplinks: "006", sec_downlinks: "0", thing: thing5)


p "****************"
p "                "
p "CREATING ACCUMULATORS"
p "                "
p "****************"
p accumulator1 = Accumulator.create(value: "0001", uplink: uplink1)
p accumulator2 = Accumulator.create(value: "0002", uplink: uplink2)
p accumulator3 = Accumulator.create(value: "0003", uplink: uplink3)
p accumulator4 = Accumulator.create(value: "0004", uplink: uplink4)
p accumulator5 = Accumulator.create(value: "0005", uplink: uplink5)
p accumulator6 = Accumulator.create(value: "0006", uplink: uplink6)

p "****************"
p "                "
p "CREATING ALARMS"
p "                "
p "****************"

p alarm1 = Alarm.create(value: "0001", viewed: false, uplink: uplink1)
p alarm2 = Alarm.create(value: "0002", viewed: false, uplink: uplink2)
p alarm3 = Alarm.create(value: "0003", viewed: false, uplink: uplink3)

p "****************"
p "                "
p "CREATING BATTERYLEVELS"
p "                "
p "****************"

p BatteryLevel.create(value: "0001", uplink: uplink1)
p BatteryLevel.create(value: "0002", uplink: uplink2)
p BatteryLevel.create(value: "0003", uplink: uplink3)
p BatteryLevel.create(value: "0004", uplink: uplink4)
p BatteryLevel.create(value: "0005", uplink: uplink5)
p BatteryLevel.create(value: "000f", uplink: uplink6)

p "****************"
p "                "
p "CREATING LOCATIONS WITH REPORTS"
p "                "
p "****************"
p billing = ScheduleBilling.create(stratum: 3, billing_period: 'month', start_date: Date.today, basic_charge_price: 13.841, basic_price: 2.100, extra_price: 1.100)
p report = ScheduleReport.create(email: "ivillamor@procibernetica.com", frequency_interval: 2, start_date: Date.today)

p city = City.find_by(name: 'Bogota')

p location1 = Location.create(name: "apartamento", address: "Carrera 7 # 71 -21", latitude: 4.1, longitude: 74.1, thing: thing1, schedule_billing: billing, schedule_report: report, city: city)
p location2 = Location.create(name: 'casa', address: "Carrera 68D # 39 - 46", latitude:  5.1, longitude: 75.1, thing: thing2)
p location3 = Location.create(name: 'negocio', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing3)
p location4 = Location.create(name: 'negocio2', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing4)
p location5 = Location.create(name: 'negocio3', address: "Carrera 15 # 27 - 19 sur", latitude: 6.1, longitude: 76.1, thing: thing5)


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
