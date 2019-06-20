  class ThingSerializer < ActiveModel::Serializer
    attributes  :id,
                :name,
                :status,
                :pac,
                :company_id,
                :created_at,
                :updated_at,

                :last_uplink,
                :last_messages

    MESSAGES = [:accumulator, :alarm, :batteryLevel, :valvePosition, :sensor1, :sensor2,
                :sensor3, :sensor4, :uplinkBDownlink, :timeUplink]

    def last_uplink
      UplinkSerializer.new(object.uplinks.order(:created_at).last)
    end

    #Return json with the last MESSAGES saved in database of the Device(Thing)
    def last_messages
      customized_last_messages = []
      custom_message = {}
      #Hash.new(accumulator: {}, alarm: {}, batteryLevel: {}, valvePosition: {}, sensor1: {}, sensor2: {},
       #         sensor3: {}, sensor4: {}, uplinkBDownlink: {}, timeUplink: {})
      MESSAGES.each do |message_name|
        hola = object.uplinks.send(message_name.to_s).order(:created_at).last
        custom_message[message_name] = hola
        customized_last_messages.push(custom_message[message_name])
      end

      customized_last_messages
    end
end
