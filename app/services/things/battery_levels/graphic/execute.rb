module Things::BatteryLevels::Graphic
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                      with: Common::Operations::Validator.(:get, :battery_level)
    step :get_thing,                       with: Things::Get.new
    step :get_battery_levels,              with: Things::BatteryLevels::Get.new
    map  :get_upward_transition,           with: Things::BatteryLevels::Graphic::UpwardTransition.new
    map  :get_last_power_connection_alarm, with: Things::BatteryLevels::Graphic::PowerConnectionAlarm.new
    map  :compare_dates,                   with: Things::BatteryLevels::Graphic::Compare.new
    map  :build_response,                  with: Things::BatteryLevels::Graphic::BuildResponse.new
  end.Do
end

