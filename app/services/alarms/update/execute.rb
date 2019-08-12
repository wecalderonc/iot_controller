module Alarms::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:update, :alarm)
    step :get_alarm,             with: Alarms::Get.new
    step :update,                with: Alarms::Update::Update.new
    map  :build_response,        with: Alarms::Update::BuildResponse.new
  end.Do
end
