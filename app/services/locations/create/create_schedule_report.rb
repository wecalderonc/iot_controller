require 'dry/transaction'

module Locations::Create
  include Dry::Transaction

  DateScheduleReport = -> input do
    Locations::ParseDate.new.(input[:schedule_report])
  end

  AssignScheduleReport = -> input do
    input[:location].update(schedule_report: input[:schedule_report])
  end

  _, CreateScheduleReport = Common::TxMasterBuilder.new do
    tee  :parse_date,      with: DateScheduleReport
    step :create_schedule, with: Locations::ScheduleR.new
    tee  :assign_schudule, with: AssignScheduleReport
  end.Do
end
