module Locations::Create
  _, Execute = Common::TxMasterBuilder.new do
    tee  :parse_input,              with: Locations::ParseInput.new
    step :validation,               with: Common::Operations::Validator.(:create, :location)
    step :get_thing,                with: Things::Get.new
    step :create_location,          with: Locations::Create::CreateLocation.new
    step :assign_contry_state_city, with: Locations::CountryStateCity.new
    step :create_schedule_billing,  with: Locations::Create::CreateScheduleBilling.new
    step :create_schedule_report,   with: Locations::Create::CreateScheduleReport.new
    map  :build_response,           with: Locations::Create::BuildResponse.new
  end.Do
end
