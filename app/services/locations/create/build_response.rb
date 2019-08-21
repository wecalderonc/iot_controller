require 'dry/transaction'

class Locations::Create::BuildResponse
  include Dry::Transaction

  Assign = -> input do
    input[:location].update(
      schedule_billing: input[:schedule_billing],
      schedule_report: input[:schedule_report]
    )
  end

  def call(input)
    Assign.(input)
    input[:location]
  end

end
