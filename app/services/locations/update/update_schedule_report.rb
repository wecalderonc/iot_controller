require 'dry/transaction'

class Locations::Update::UpdateScheduleReport
  include Dry::Transaction

  def call(input)
    Locations::ParseDate.new.(input[:schedule_report])
    Locations::Update::Schedule.new.(input, :schedule_report)
  end
end
