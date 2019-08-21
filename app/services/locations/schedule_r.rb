require 'dry/transaction'

class Locations::ScheduleR
  include Dry::Transaction

  def call(input)
    puts "*" * 100
    puts input.inspect
    puts "*" * 100

    schedule = ScheduleReport.new(input[:schedule_report])

    if schedule.save
      input[:schedule_report] = schedule

      Success input
    else
      Failure Errors.general_error(schedule.errors.messages, self.class)
    end
  end
end
