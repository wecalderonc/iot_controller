module Locations::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,               with: Common::Operations::Validator.(:create, :location)
    step :get_thing,                with: Things::Get.new
    step :create_location,          with: Locations::Create::CreateLocation.new
    step :assign_contry_state_city, with: Locations::Create::CountryStateCity.new
#   step :create_schedule_billing,  with: Locations::Create::ScheduleBilling.new
#   step :create_schedule_report,   with: Locations::Create::ScheduleReport.new
  end.Do
end
