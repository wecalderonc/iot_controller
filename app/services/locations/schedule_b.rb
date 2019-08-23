require 'dry/transaction'

class Locations::ScheduleB
  include Dry::Transaction

  def call(input)
    schedule = ScheduleBilling.new(input[:schedule_billing])

    if schedule.save
      input[:schedule_billing] = schedule

      Success input
    else
      Failure Errors.general_error(schedule.errors.messages, self.class)
    end
  end
end
