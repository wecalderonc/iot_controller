class BatteryLevelSerializer < UplinkBaseSerializer
  attributes :level_label

  def level_label
    battery_value = object.value[-1].to_i
    BatteryLevel::LEVEL_LABELS[battery_value]
  end
end
