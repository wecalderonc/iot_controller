module Locations::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                with: Common::Operations::Validator.(:create, :location)
    step :get_user,                  with: Users::Get.new
    step :get_thing,                 with: Things::Get.new
    step :validate_thing_location,   with: Things::ValidateLocation.new
    step :validate_user,             with: Locations::Create::ValidateUser.new
    step :create_location,           with: Locations::Create::CreateLocation.new
    step :assign_country_state_city, with: Locations::CountryStateCity.new
    step :create_schedule_billing,   with: Locations::Create::CreateScheduleBilling.new
    step :create_schedule_report,    with: Locations::Create::CreateScheduleReport.new
    map  :build_response,            with: Locations::Create::BuildResponse.new
  end.Do
end
