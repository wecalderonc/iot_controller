class ThingDashboardSerializer < ThingBasicSerializer
  attributes    :last_battery_level

  def last_battery_level
    battery_level = object.uplinks.batteryLevel.order(:created_at).last

    options = {
        true => -> { BatteryLevelSerializer.new(battery_level) },
        false => -> { {} }
      }[battery_level.present?].()
  end
end
