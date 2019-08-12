# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' , { name: 'Lord of the Rings' ])
#   Character.create(name: 'Luke', movie: movies.first)

#Thing.create(name: "device1")
#Thing.create(name: "device2")
#Thing.create(name: "device3")
#Thing.create(name: "device4")


user1 = User.create(first_name:"javier", last_name: "varon", phone: "31261258231",
            gender: "male", id_number: "1645634", user_type: "amigo", id_type: "1",
            email: "jvaron@procibernetica.com", password: "javier123" )

user2 = User.create(first_name:"william", last_name: "calderon", phone: "3013632461",
            gender: "male", id_number: "123456", user_type: "amigo", id_type: "1",
            email: "wcalderon@procibernetica.com", password: "123456" )

user3 = User.create(first_name:"daniela", last_name: "", phone: "3123204312",
            gender: "male", id_number: "364553", user_type: "amigo", id_type: "2",
            email: "dpatino@procibernetica.com", password: "dani123" )

thing1 = Thing.create(name: "thing", status: "activated", pac: "io46eui4oe6uioe1ui6o4", company_id: "12", latitude: 4, longitude: 75)

thing2 = Thing.create(name: "thing two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20", latitude: 4, longitude: 75)

thing3 = Thing.create(name: "thing tree", status: "desactivated", pac: "fdsau45eo69u4aoe32u1a", company_id: "54", latitude: 4, longitude: 75)

uplink1 = Uplink.create(data: "016774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing1)

uplink2 = Uplink.create(data: "026774300806702ffff10040", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing2)

uplink3 = Uplink.create(data: "035647200806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing3)


acumulator1 = Accumulator.create(value: rand(1000), uplink: uplink1)
acumulator2 = Accumulator.create(value: rand(1000), uplink: uplink2)
acumulator3 = Accumulator.create(value: rand(1000), uplink: uplink3)

alarm1 = Alarm.create(value: "jajajaja", viewed: false, date: "2019-08-12T20:27:10.000+00:00", uplink: uplink1)
alarm2 = Alarm.create(value: "jijijiji", viewed: false, date: "2019-06-12T20:27:10.000+00:00", uplink: uplink2)
alarm3 = Alarm.create(value: "jujujuju", viewed: false, date: "2019-04-12T20:27:10.000+00:00", uplink: uplink3)

#Owner.create(from_node:user1, to_node:thing1)
#Owner.create(from_node:user2, to_node:thing2)
#Owner.create(from_node:user3, to_node:thing3)
