require 'dry/transaction/operation'

class Things::Accumulators::Get
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    accumulators = thing.uplinks.accumulator

    if accumulators.present?
      Success accumulators
    else
      Failure Errors.general_error("The thing #{input[:thing_name]} does not have accumulators", self.class)
    end
  end
end
