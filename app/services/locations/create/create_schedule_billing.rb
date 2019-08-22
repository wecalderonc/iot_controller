require 'dry/transaction'

module Locations::Create
  include Dry::Transaction

  DateScheduleBilling = -> input do
    Locations::ParseDate.new.(input[:schedule_billing])
  end

  AssignScheduleBilling = -> input do
    input[:location].update(schedule_billing: input[:schedule_billing])
  end

  _, CreateScheduleBilling = Common::TxMasterBuilder.new do
    tee  :parse_date,      with: DateScheduleBilling
    step :create_schedule, with: Locations::ScheduleB.new
    tee  :assign_schedule, with: AssignScheduleBilling
  end.Do
end
