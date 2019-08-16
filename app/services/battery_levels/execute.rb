module BatteryLevels
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get, :battery_level)
    step :get_thing,             with: Things::Get.new
    step :get_battery_levels,    with: BatteryLevels::Get.new
    map  :classification,        with: BatteryLevels::Classification.new
  end.Do
end

