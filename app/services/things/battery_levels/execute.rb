module Things::BatteryLevels
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get, :battery_level)
    step :get_thing,             with: Things::Get.new
    step :get_battery_levels,    with: Things::BatteryLevels::Get.new
    map  :classification,        with: Things::BatteryLevels::Classification.new
  end.Do
end

