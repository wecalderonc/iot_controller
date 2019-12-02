class BatteryLevelSerializer < UplinkBaseSerializer
  attributes :level_label

  def level_label
    battery_value = Utils.last_digit(object.value).to_i
    BatteryLevel::LEVEL_LABELS[battery_value]
  end
end
