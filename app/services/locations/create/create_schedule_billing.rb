require 'dry/transaction'

module Locations::Create
  include Dry::Transaction

  GetDate = -> input do
    Locations::ParseDate.new.(input[:schedule_billing])
  end

  _, CreateScheduleBilling = Common::TxMasterBuilder.new do
    tee  :parse_date,      with: GetDate
    step :create_schedule, with: Locations::ScheduleB.new
  end.Do
end
