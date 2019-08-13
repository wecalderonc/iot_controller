require 'dry/transaction/operation'

class Alarms::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    input[:alarm]
  end
end
