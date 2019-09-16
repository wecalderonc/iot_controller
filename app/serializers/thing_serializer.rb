class ThingSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :status,
              :pac,
              :company_id,
              :latitude,
              :longitude,
              :units,
              :created_at,
              :updated_at,

              :valve_transition,
              :last_uplink,
              :last_messages

  MESSAGES = [:accumulator, :alarm, :batteryLevel, :valvePosition, :sensor1, :sensor2,
              :sensor3, :sensor4, :uplinkBDownlink, :timeUplink]

  def last_uplink
    object.last_uplinks
  end

  def last_messages
    MESSAGES.each_with_object({}) do |message_name, last_messages|
      #TODO: add base model to add get last object
      last_message = object.uplinks.send(message_name.to_s).order(:created_at).last

      last_messages[message_name] = {
        true => -> { Utils.to_constant("#{message_name}Serializer").new(last_message) },
        false => -> { {} }
      }[last_message.present?].()
    end
  end

  def valve_transition
    {
      real_state: object.valve_transition.real_state,
      showed_state: object.valve_transition.showed_state
    }
  end
end
