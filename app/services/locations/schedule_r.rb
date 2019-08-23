require 'dry/transaction'

class Locations::ScheduleR
  include Dry::Transaction

  def call(input)
    schedule = ScheduleReport.new(input[:schedule_report])

    if schedule.save
      input[:schedule_report] = schedule

      Success input
    else
      Failure Errors.general_error(schedule.errors.messages, self.class)
    end
  end
end
