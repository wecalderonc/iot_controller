class LocationDashboardSerializer < ActiveModel::Serializer
  attributes  :id,
              :name

  has_one :thing

  #             :new_alarms,
  #             :valve_transition,
  #             :last_uplink,
  #             :last_messages

  # MESSAGES = [:accumulator, :alarm, :batteryLevel, :valvePosition, :sensor1, :sensor2,
  #             :sensor3, :sensor4, :uplinkBDownlink, :timeUplink]

  # def last_uplink
  #   object.last_uplinks
  # end

  # def new_alarms
  #   object.has_new_alarms?
  # end

  # def valve_transition
  #   {
  #     real_state: object.valve_transition.real_state,
  #     showed_state: object.valve_transition.showed_state
  #   }
  # end
end
