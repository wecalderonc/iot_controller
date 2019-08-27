require 'dry/transaction'

class Locations::Update::ScheduleB
  include Dry::Transaction

  def call(input)
    schedule = input[:location].schedule_billing

    if schedule.update(input[:schedule_billing])
      Success input
    else
      Failure Errors.general_error(location.errors.messages, self.class)
    end
  end
end
