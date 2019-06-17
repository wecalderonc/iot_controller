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

Uplink.create(data: "006774300806702ffff10000", avgsnr: "18.47", rssi: "-530.00",
              long: "-74.0", lat: "5.0", snr: "16.32", station: "146A", seqnumber: "77",
              time: "1548277798", sec_uplinks: "006", sec_downlinks: "0")

User.create(first_name:"javier", last_name: "varon", phone: "31261258231",
            gender: "male", id_number: "1645634", user_type: "amigo", id_type: "1",
            email: "jvaron@procibernetica.com", password: "javier123" )

Thing.create(name: "thing", status: "activated", pac: "io46eui4oe6uioe1ui6o4", company_id: "12")
Thing.create(name: "thing two", status: "desactivated", pac: "enrau45eo69u4aoe32u1a", company_id: "20")
