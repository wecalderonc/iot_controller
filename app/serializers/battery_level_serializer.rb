class BatteryLevelSerializer < UplinkBaseSerializer
  attributes :name

  def name
    battery_value = object.value.to_i
    BatteryLevel::LEVEL_LABELS[battery_value]
  end
end
