module Locations::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,               with: Common::Operations::Validator.(:create, :location)
#   step :create_location,          with: Locations::Create::Location.new
#   step :assign_contry,            with: Locations::Create::AssignCountry.new
#   step :create_schedule_billing,  with: Locations::Create::ScheduleBilling.new
#   step :create_schedule_report,   with: Locations::Create::ScheduleReport.new
  end.Do
end
