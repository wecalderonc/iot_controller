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

<<<<<<< Updated upstream
=======
=begin
User.create(first_name:"javier", last_name: "varon", phone: "31261258231",
       gender: "male", id_number: "1645634", user_type: "amigo", id_type: "1",
       email: "jvaron@procibernetica.com", password: "javier123" )
=end

t1 = Thing.create(name: "thing", status: "activated", pac: "io46eui4oe6uioe1ui6o4", company_id: "12")
t2 = Thing.create(name: "thing two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20")
t3 = Thing.create(name: "thing whitout accumulators", status: "desactivated", pac: "aoecuh46oua4o6aeu1ao", company_id: "25")

u1 = Uplink.create(data: "006774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0")
>>>>>>> Stashed changes

u2 = Uplink.create(data: "006774300806702ffff10000", avgsnr: "16.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0")

u3 = Uplink.create(data: "006774300806702ffff10000", avgsnr: "15.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0")

a1 = Accumulator.create(value: "00008dbc")
a2 = Accumulator.create(value: "00006dbc")
a3 = Accumulator.create(value: "00007dbc")

#Relationships

t1.uplinks_created = [u1, u2]
u1.accumulator = a1
u2.accumulator = a2

<<<<<<< Updated upstream
User.create(first_name:"william", last_name: "calderon", phone: "3013632461",
            gender: "male", id_number: "123456", user_type: "amigo", id_type: "1",
            email: "wcalderon@procibernetica.com", password: "123456" )

thing = Thing.create(name: "thing", status: "activated", pac: "io46eui4oe6uioe1ui6o4", company_id: "12")
thing2 = Thing.create(name: "thing two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20")

Uplink.create(data: "006774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0", thing: thing)

Accumulator.create(value: rand(1000), uplink: uplink2)
=======
t2.uplinks_created = [u3]
u3.accumulator = a3
>>>>>>> Stashed changes
