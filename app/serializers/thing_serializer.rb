class ThingSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :status,
              :pac,
              :company_id,
              :latitude,
              :longitude,
              :units,
              :coordinates,
              :created_at,
              :updated_at,

              :last_uplink,
              :last_messages

  MESSAGES = [:accumulator, :alarm, :batteryLevel, :valvePosition, :sensor1, :sensor2,
              :sensor3, :sensor4, :uplinkBDownlink, :timeUplink]

  def last_uplink
    object.last_uplinks
  end

  def last_messages
    MESSAGES.each_with_object({}) do |message_name, last_messages|
      last_message = object.uplinks.send(message_name.to_s).order(:created_at).last

      last_messages[message_name] = {
        true  => -> { MessagesInsideUplinkSerializer.new(last_message) },
        false => -> { {} }
      }[last_message.present?].()
    end
  end
end
