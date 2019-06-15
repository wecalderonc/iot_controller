# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Uplink.create(name: "uplink1")
Uplink.create(name: "uplink2")
Uplink.create(name: "uplink3")
Uplink.create(name: "uplink4")

Thing.create(name: "device1")
Thing.create(name: "device2")
Thing.create(name: "device3")
Thing.create(name: "device4")


User.create(first_name:"javier", last_name: "varon", phone: "31261258231", gender: "male", id_number: "1645634", user_type: "amigo", id_type: "1", email: "jvaron@procibernetica.com" )
