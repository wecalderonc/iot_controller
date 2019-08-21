require 'dry/transaction'

module Locations::Create
  include Dry::Transaction

  GetDate = -> input do
    Locations::ParseDate.new.(input[:schedule_report])
  end

  Assign = -> input do
    input[:location].update(schedule_report: input[:schedule_report])
  end

  _, CreateScheduleReport = Common::TxMasterBuilder.new do
    tee  :parse_date,      with: GetDate
    step :create_schedule, with: Locations::ScheduleR.new
    tee  :assign_location, with: Assign
  end.Do
end
