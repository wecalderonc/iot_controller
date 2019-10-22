module Things::BatteryLevels::Graphic
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                     with: Common::Operations::Validator.(:get, :battery_level)
    step :get_thing,                      with: Things::Get.new
    step :get_alarms,                     with: Things::Alarms::Get.new
    step :get_last_power_connection_alarm with: Things::BatteryLevels::Graphic::PowerConnectionAlarm.new
    step :get_upward_transition           with: Things::BatteryLevels::Graphic::Upward.new
    step :compare_dates                   with: Things::BatteryLevels::Graphic::Compare.new
    step :get_battery_levels              with: Things::BatteryLevels::Graphic::Get.new
  end.Do
end

