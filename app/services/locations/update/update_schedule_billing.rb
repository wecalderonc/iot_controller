require 'dry/transaction'

class Locations::Update::UpdateScheduleBilling
  include Dry::Transaction

  def call(input)
    Locations::ParseDate.new.(input[:schedule_billing])
    Locations::Update::Schedule.new.(input, :schedule_billing)
  end
end
