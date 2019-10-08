module Locations::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                with: Common::Operations::Validator.(:create, :location)
    step :get_user,                  with: Users::Get.new
    step :get_thing,                 with: Things::Get.new
    step :update_location,           with: Locations::Update::UpdateLocation.new
    step :assign_country_state_city, with: Locations::CountryStateCity.new
    step :update_schedule_billing,   with: Locations::Update::UpdateScheduleBilling.new
    step :update_schedule_report,    with: Locations::Update::UpdateScheduleReport.new
    map  :build_response,            with: Locations::Update::BuildResponse.new
  end.Do
end
