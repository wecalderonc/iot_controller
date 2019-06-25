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
      MESSAGES.each_with_object({}) do |message_name, last_messages|
        last_message = object.uplinks.send(message_name.to_s).order(:created_at).last
        if last_message.present?
          message_serialized = MessagesInsideUplinkSerializer.new(last_message)
        else
          message_serialized = {}
        end
        last_messages[message_name] = message_serialized
      end
    end
end
