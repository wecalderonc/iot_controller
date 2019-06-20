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
      customized_last_messages = {}
      custom_message = {}

      MESSAGES.each do |message_name|
        last_message = object.uplinks.send(message_name.to_s).order(:created_at).last
        if last_message
          message_serialized = MessagesInsideUplinkSerializer.new(last_message)
        else
          message_serialized = {}
        end
        customized_last_messages[message_name] = message_serialized
      end
      customized_last_messages
    end
end
