class ThingBasicSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,

              :valve_transition,
              :new_alarms

  def new_alarms
    object.has_new_alarms?
  end

  def valve_transition
    {
      real_state: object.valve_transition.real_state,
      showed_state: object.valve_transition.showed_state
    }
  end
end
