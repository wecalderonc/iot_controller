module Things::Alarms::Index
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get, :alarm)
    step :get_thing,             with: Things::Get.new
    step :get_alarms,            with: Things::Alarms::Get.new
  end.Do
end
