
module Locations::Update
  _, Execute = Common::TxMasterBuilder.new do
    tee  :parse_input,              with: Locations::ParseInput.new
    step :validation,               with: Common::Operations::Validator.(:create, :location)
    step :get_thing,                with: Things::Get.new
    step :validate_thing,           with: Locations::Update::ValidateThing.new
    step :update_location,          with: Locations::Update::UpdateLocation.new
    step :assign_contry_state_city, with: Locations::CountryStateCity.new
    step :update_schedule_billing,  with: Locations::Update::UpdateScheduleBilling.new
    step :update_schedule_report,   with: Locations::Update::UpdateScheduleReport.new
    map  :build_response,           with: Locations::Update::BuildResponse.new
  end.Do
end
